import { CustomEditor, type ExtensionAPI } from "@earendil-works/pi-coding-agent";
import { isKeyRelease, matchesKey, type ScrollView, type TUI } from "@earendil-works/pi-tui";

// Prompt jumping and primary viewport access use private Pi methods.
type Transcript = TUI & {
  scrollBy(lines: number): void;
  scrollToTop(): void;
  scrollToBottom(): void;
  scrollToPrompt(direction: -1 | 1): void;
  getPrimaryScrollView(): ScrollView;
};

export default function (pi: ExtensionAPI): void {
  let active = false;
  let cleanup: (() => void) | undefined;
  let setCursor = (_navigation: boolean) => {};
  const exit = () => { if (active) { active = false; setCursor(false); } };

  pi.on("session_start", (_event, ctx) => {
    if (ctx.mode !== "tui") return;
    const previous = ctx.ui.getEditorComponent();
    let removeInput: (() => void) | undefined;
    let restoreRender: (() => void) | undefined;
    const factory: NonNullable<typeof previous> = (tui, theme, keybindings) => {
      exit();
      removeInput?.();
      restoreRender?.();
      const editor = (previous?.(tui, theme, keybindings)
        ?? new CustomEditor(tui, theme, keybindings, { embedWorkingStatus: true })) as CustomEditor;
      const transcript = tui as Transcript;
      if (tui.mode !== "fullscreen") return editor;

      setCursor = (navigation) => {
        const mode = Reflect.get(editor, Symbol.for("pi-vim-editor")).status().mode;
        const shape = navigation ? 2 : mode === "insert" ? 6 : mode === "replace" ? 4 : 2;
        tui.terminal.write(`\x1b[${shape} q`);
      };
      const originalRender = editor.render;
      const render: typeof editor.render = (width) => {
        const lines = originalRender.call(editor, width);
        // Reassert after the Vim editor renders its own cursor shape.
        if (active && editor.focused && !tui.hasOverlay()) setCursor(true);
        return lines;
      };
      editor.render = render;
      restoreRender = () => { editor.render = originalRender; };

      removeInput = ctx.ui.onTerminalInput((data) => {
        if (tui.hasOverlay() || !editor.focused || editor.isShowingAutocomplete()) return;
        if (isKeyRelease(data)) return active ? { consume: true } : undefined;
        if (matchesKey(data, "ctrl+b")) {
          active = !active;
          setCursor(active);
          if (active) {
            const view = transcript.getPrimaryScrollView();
            view.scrollTo(view.scrollTop, { disableFollow: true });
          }
          return { consume: true };
        }
        if (!active) return;
        if (data === "\x1b[I" || data === "\x1b[O") return;
        if (/^\x1b\[</u.test(data)) { exit(); return; }
        if (matchesKey(data, "g")) {
          transcript.scrollToTop();
        } else if (matchesKey(data, "shift+g")) {
          transcript.scrollToBottom();
        } else if (matchesKey(data, "escape") || matchesKey(data, "ctrl+c") || data === "i" || data === "q") {
          exit();
        } else if (matchesKey(data, "shift+j")) {
          transcript.scrollToPrompt(1);
        } else if (matchesKey(data, "shift+k")) {
          transcript.scrollToPrompt(-1);
        } else if (matchesKey(data, "j") || matchesKey(data, "k")) {
          transcript.scrollBy(matchesKey(data, "j") ? 1 : -1);
        } else if (matchesKey(data, "d") || matchesKey(data, "u")) {
          const halfPage = Math.max(1, Math.floor(transcript.getPrimaryScrollView().viewportHeight / 2));
          transcript.scrollBy(matchesKey(data, "d") ? halfPage : -halfPage);
        }
        return { consume: true };
      });
      return editor;
    };
    ctx.ui.setEditorComponent(factory);
    cleanup = () => {
      exit();
      removeInput?.();
      restoreRender?.();
      ctx.ui.setEditorComponent(previous);
    };
  });

  pi.on("session_before_switch", exit);
  pi.on("session_before_tree", exit);
  pi.on("session_before_fork", exit);
  pi.on("session_shutdown", () => cleanup?.());
}
