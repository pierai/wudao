首先备份一下以下三个文件：review.codex.md、review.gemini.md 和 review.claude.md，然后清空这三个文件的内容。如果文件不存在的话，就忽略。

接着起三个并行的 subagent，分别做以下事情：

1. 使用codex review我的代码变更：运行 `codex exec --full-auto "review我的代码变更，输入markdown格式，并且将结果保存到review.codex.md文件中"`
2. 使用gemini review我的代码变更：运行 `gemini --yolo "review我的代码变更，输入markdown格式，并且将结果保存到review.gemini.md文件中"`
3. 你自己Review 我的代码变更，并且将结果保存到review.claude.md中
以上这三个任务应该是并行的。

等三个subagent全部结束以后，综合这三个文件的内容：review.codex.md、review.gemini.md 和review.claude.md给我列一下这次代码 review 我最需要关注的几个点。
