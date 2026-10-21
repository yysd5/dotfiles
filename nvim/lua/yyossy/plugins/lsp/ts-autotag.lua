-- HTML/JSX等のタグを自動で閉じる・リネームする
return {
  "windwp/nvim-ts-autotag",
  event = { "BufReadPre", "BufNewFile" },
  opts = {},
}
