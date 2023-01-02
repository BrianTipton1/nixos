[
  {
    key = "ctrl+l";
    command = "-notebook.centerActiveCell";
    when = "notebookEditorFocused";
  }
  {
    key = "ctrl+l";
    command = "-extension.vim_navigateCtrlL";
    when = "editorTextFocus && vim.active && vim.use<C-l> && !inDebugRepl";
  }
  {
    key = "ctrl+l";
    command = "-expandLineSelection";
    when = "textInputFocus";
  }
  {
    key = "ctrl+l";
    command = "workbench.action.closeSidebar";
  }
  {
    key = "ctrl+l";
    command = "workbench.action.toggleSidebarVisibility";
  }
  {
    key = "ctrl+b";
    command = "-workbench.action.toggleSidebarVisibility";
  }
]
