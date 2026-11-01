import {
  existsSync,
  readFileSync,
  renameSync,
  rmSync,
  writeFileSync,
} from "node:fs";
import { join } from "node:path";
import {
  getAgentDir,
  withFileMutationQueue,
  type ExtensionAPI,
} from "@earendil-works/pi-coding-agent";

type Settings = Record<string, unknown>;
const isObject = (value: unknown): value is Settings =>
  value !== null && typeof value === "object" && !Array.isArray(value);

function parse(text: string, jsonc = false): Settings {
  if (jsonc) {
    // Match strings first so comment-like text inside them stays untouched.
    text = text.replace(
      /"(?:\\.|[^"\\])*"|\/\/[^\r\n]*|\/\*[\s\S]*?\*\//g,
      (token) =>
        token.startsWith('"') ? token : token.replace(/[^\r\n]/g, " "),
    );
  }
  const value: unknown = JSON.parse(text);
  if (!isObject(value)) throw new Error("Settings must contain a JSON object");
  return value;
}

// Shared values win; objects merge, arrays replace, and local-only keys survive.
function merge(local: Settings, shared: Settings): Settings {
  return Object.fromEntries([
    ...Object.entries(local),
    ...Object.entries(shared).map(([key, value]) => [
      key,
      isObject(value)
        ? merge(isObject(local[key]) ? local[key] : {}, value)
        : value,
    ]),
  ]);
}

export default function (pi: ExtensionAPI) {
  let running = false;
  pi.registerCommand("config-sync", {
    description: "Merge shared settings, reconcile packages, and reload",
    handler: async (args, ctx) => {
      if (args.trim()) {
        ctx.ui.notify("Usage: /config-sync", "error");
        return;
      }
      if (running) return;
      running = true;
      try {
        await ctx.waitForIdle();
        const agentDir = getAgentDir();
        const settingsPath = join(agentDir, "settings.json");
        const sharedPath = join(agentDir, "settings.shared.jsonc");
        await withFileMutationQueue(settingsPath, async () => {
          const shared = parse(readFileSync(sharedPath, "utf8"), true);
          const original = existsSync(settingsPath)
            ? readFileSync(settingsPath, "utf8")
            : undefined;
          const local = original === undefined ? {} : parse(original);
          const merged = merge(local, shared);
          if (JSON.stringify(local) === JSON.stringify(merged)) return;
          if (original !== undefined)
            writeFileSync(`${settingsPath}.bak`, original, { mode: 0o600 });
          const temporaryPath = `${settingsPath}.${process.pid}.tmp`;
          try {
            writeFileSync(
              temporaryPath,
              `${JSON.stringify(merged, null, 2)}\n`,
              { mode: 0o600 },
            );
            renameSync(temporaryPath, settingsPath);
          } finally {
            rmSync(temporaryPath, { force: true });
          }
        });
        ctx.ui.notify("Settings synced. Reconciling packages…", "info");
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
