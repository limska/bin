# MIGRATION.md

Tracks the port from mixed shell/Go/Python → xonsh, per-script. Scope: only
plain shell scripts get ported. Go stays Go. Scripts that bootstrap a fresh
machine (run before xonsh/python exist) stay POSIX sh forever.

Status values: `bootstrap` (sh, never ported) · `go` (untouched) ·
`keep` (python/perl/ansible, not in scope) · `todo` (shell → xonsh) ·
`done` · `remove?` (dead, needs your confirm) · `merge?` (duplicate/overlap,
needs your confirm on which survives).

## Bootstrap tier (stays sh)

| Script | Notes |
|---|---|
| clone-repos.sh | clones bin/dotfiles/dotfiles_local/keys |
| clone-ianus.sh | clones StromungsRaum repo set |
| make-links.sh | symlinks dotfiles, installs fzf |
| github-add-key.sh | one-time key upload |
| get_runner.sh | installs uv, clones runner — also overlaps clone-ianus.sh, see remove? list |
| env.sh | **flagged** — content is CD-adapco/STAR-CCM+ toolchain PATH setup, not generic bootstrap. You picked this as bootstrap-tier; confirm it's still live or it's really a `remove?` |
| setdev | same flag as env.sh — STAR-CCM+ dev-tree PATH switcher |
| setrel | same flag as env.sh — STAR-CCM+ release-tree PATH switcher |

## Go (untouched)

| Script | Notes |
|---|---|
| deploy.go | duplicates deploy.sh — see merge? list |
| teams_post.go | duplicates teams_post.py — see merge? list |

## Keep as-is (not shell)

| Script | Why |
|---|---|
| crucible.py | Python 2 (ConfigParser/urllib2) — ask if Crucible is still used at all before investing in a py3 port |
| insert_mock_data_pg.py | already python3 |
| teams_post.py | already python (uv script) |
| git-difftool | perl |
| git-difftool-helper | not fully read — confirm language before touching |
| install-common.yaml | ansible |
| LICENSE, README.md | docs |

## todo: shell → xonsh (active, worth porting)

| Script | Notes |
|---|---|
| pull-repos.sh | shares repo-loop logic with push/status/uv-sync — factor into `lib/mytools/repos.py` |
| push-repos.sh | " |
| status-repos.sh | " |
| uv-sync-repos.sh | " |
| hotrunner.sh | |
| run-pumps.sh | |
| mirror2gitlab.sh | |
| rename_main.sh | |
| set-github-noreply-email.sh | |
| make_icons | |
| mkBourne755 | |
| png2mp4 | |
| screencast.sh | |
| test_ports | |
| makemsc | |
| msc2svg | |
| starfinder | |
| git-diff-wrapper.sh | trivial meld wrapper — maybe fold into git-difftool-helper config instead of porting standalone |
| python-apptainer | **bug**: unconditionally appends `"$@"` to `/home/sava/test.log` on every run — leftover debug line, strip it during port |
| aws_sso_login | **bug**: sources `$HOME/bin/env` — that file doesn't exist, only `env.sh`. Broken today. |
| service-sentry-env | same **bug**: sources `$HOME/bin/env`, doesn't exist |
| compile_latex.sh | generic, low-risk, low-priority |

## merge? (not dead, but duplicated — pick one, delete the rest)

| Group | Issue |
|---|---|
| `deploy.sh` vs `deploy.go` | same job, two languages. Also deploy.sh has a latent bug: `LINK_BASE` is computed once inside the if/else fallback, then unconditionally recomputed right after from `$LINK_FILE` — if `LINK_FILE` is empty that second line clobbers the fallback with garbage. |
| `teams_post.py` vs `teams_post.go` | same job, two languages |
| `make_openssl` vs `make-openssl.sh` | near-identical build recipe, literal duplicate |
| `submit_array.sh` vs `submit_array.xsh` | `.xsh` already exists and is more complete (checks `proc.returncode` properly). `.sh` is dead weight → straight `remove?`, not even a merge decision |
| `kill_abaqus` vs `kill_abq` | two scripts, same goal (kill Abaqus procs), different method |
| `make_pull_request`, `make_merge_request`, `make_fix_merge_request`, `make_patch_request`, `make_patch_from_cherry_pick`, `make_patch_from_file`, `patch.sh` | 7 scripts, same branch+commit+push+glab-mr skeleton with small variations — one parametrized xonsh script with subcommands would replace all 7 |
| `eclipsefea`, `eclipse-laptop`, `ejava`, `nb`, `LaTeXDraw` | all "launch IDE/jar with hardcoded old JDK path" — same pattern 5 times |
| `clone-ianus.sh` vs `get_runner.sh` | both clone subsets of the StromungsRaum repo set for machine setup — overlapping purpose |

## remove? (dead — hardcoded paths/hosts from old jobs, or broken tooling)

All of these reference machines, usernames, or orgs that look gone
(cd-adapco, plm.eds.com, old `lonli6009a` user, Abaqus-era paths). Confirm
before I delete anything — I'm not touching these without your say-so.

| Script | Why it looks dead |
|---|---|
| abqtest | hardcoded `/u/cd8rit/database`, old Abaqus test harness |
| blowstartest.sh | hardcoded `/users/lonli6009a/...`, `stash.cd-adapco.com` |
| configure_vim | hardcoded STAR-CCM+ python 2.7/3.4 paths |
| copyPaste | CD-adapco cosimulation C++/Java codebase specific |
| cpp2javasync | same CD-adapco codebase rsync |
| ddd | hardcoded old STAR-CCM+ lib path for gdb wrapper |
| eclipsefea / eclipse-laptop / ejava | hardcoded STAR-CCM+ JDK/eclipse paths |
| epolish | nagfor-specific Fortran formatter — dead unless still writing Fortran |
| fast-track | hardcoded dev path + `stash.cd-adapco.com` remote |
| getClang | uses retired `svn.llvm.org` — LLVM moved off SVN years ago, this is broken today, not just unused |
| go.sh | STAR-CCM+ 9.01 API example builder, hardcoded Intel 11.1 compiler path |
| gt2016.sh / gtenv.sh | old GTI/Abaqus test env, hardcoded `/users/install2` |
| kill_abaqus / kill_abq | only relevant if you still run Abaqus |
| LaTeXDraw | hardcoded STAR-CCM+ JDK path just to launch a jar |
| ldpath | STAR-CCM+ build-tree-specific run script |
| machine | shells out to `finger` — likely not even installed anymore |
| make_clang / make_gcc / make_openssl / make-openssl.sh / make_python2 / make_python3 / make_vim | toolchain-from-source builders tied to old `$HOME/src/starccm` tree |
| makeinstall | STAR-CCM+ build/install packaging, old release flow |
| nb | NetBeans launcher, hardcoded STAR-CCM+ JDK path |
| ping_playbook.xml | looks like a scratch ansible smoke-test, not a reusable tool |
| submit_array.sh | superseded by submit_array.xsh (see merge? list) |
| sync | rsync between dead CD-adapco hosts (`phaethon`, `xeona42.austin`) |
| sync_cae_nxn.sh | NX/Nastran sync against `plm.eds.com` infra |
| tmux-blue-fox.sh | old job's repo layout (`amt-services`, `blue-fox`) |
| tmux-build.sh / tmux-startest.sh | STAR-CCM+ build-tree tmux layouts |
| upload-ixml.sh | `gitinternal.nag.co.uk` — confirm if NAG is still current work |
| wave.sh | Ricardo Wave software PATH setup, job-specific |

## Not yet classified / need a decision

- `env.sh`, `setdev`, `setrel` — see bootstrap-tier flag above.
- `crucible.py` — still used?
- `git-difftool-helper` — not read in full, confirm it's worth keeping before porting its wrapper.
