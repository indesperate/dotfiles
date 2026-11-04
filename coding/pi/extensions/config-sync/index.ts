import { join } from "node:path";
import {
  getAgentDir,
  withFileMutationQueue,
  type ExtensionAPI,
} from "@earendil-works/pi-coding-agent";

export default function (pi: ExtensionAPI) {
  let running = false;
  pi.registerCommand("config-sync", {
    description: "Sync settings and packages, then reload",
    handler: async (_args, ctx) => {
      if (running) return;
      running = true;
      try {
        await ctx.waitForIdle();
        const agentDir = getAgentDir();
        const settingsPath = join(agentDir, "settings.json");
        await withFileMutationQueue(settingsPath, async () => {
          const result = await pi.exec("mise", ["dot", "apply", settingsPath], {
            cwd: agentDir,
            timeout: 30_000,
          });
          if (result.code !== 0 || result.killed) {
            throw new Error(
              `Settings merge failed. Run mise dot diff to inspect it.\n${result.stderr.trim()}`,
            );
          }
        });
        const result = await pi.exec("pi", ["update", "--extensions"], {
          cwd: agentDir,
          timeout: 120_000,
        });
        if (result.code !== 0 || result.killed) {
          throw new Error(
            "Package sync failed; settings were kept. Retry with pi update --extensions.",
          );
        }
      } catch (error) {
        ctx.ui.notify(
          error instanceof Error ? error.message : String(error),
          "error",
        );
        return;
      } finally {
        running = false;
      }
      ctx.ui.notify(
        "Config synced. Reloading; restart Pi for startup-only defaults.",
        "info",
      );
      await ctx.reload();
    },
  });
}
