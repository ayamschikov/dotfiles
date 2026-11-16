cd ~/projects/garden/docs/log && python3 - <<'EOF'
p='INDEX.md'; s=open(p).read().split('\n')
i=[k for k,l in enumerate(s) if l.startswith('- 2026-10-02')][0]
s[i]=s[i].rstrip()+"; END: last day of the sprint; build fix resolved (stale cache); v1.2.3 10:06Z, checks CLEAN; release PROJ-200 (!300) started 14:54Z, not finished by 15:52Z; disk usage rising 3rd evening; notes in end-of-day.md"
open(p,'w').write('\n'.join(s))
EOF
mkdir -p ~/projects/todo/notes; cat > ~/projects/todo/notes/sprint-summary.md <<'EOF'
# Итоги спринта — продолжить в понедельник

**Цель:** через неделю я сам пойму, что было сделано, что осталось и кого ждать. Плюс страница с итогами в вики.

**Где всё лежит:**
- `~/projects/garden/docs/log/INDEX.md` — строка на день;
- `docs/log/<дата>/end-of-day.md` и `activity-log.md`;
- разборы: `docs/log/2026-10-01/investigations/{build-fix,disk-usage}.md`.

**Что проверить перед итогами:** дошёл ли релиз PROJ-200 (!300) до сервера; ответы соседей по проекту; что берём в следующий спринт.

**Правила:** только черновик; публикация в вики/Slack — по команде через drafts → `~/.claude/bin/review text` → `publish-approve`; факты со ссылками, догадки помечать.

**Продолжить:** `claude --resume sprint-summary`.
EOF
python3 - <<'EOF'
import os
p=os.path.expanduser('~/projects/todo/todo.md'); s=open(p).read().split('\n')
def pop(prefix):
    i=[k for k,l in enumerate(s) if l.startswith(prefix)]
    return s.pop(i[0]) if i else None
pop('- [ ] разобраться со сборкой 01.10')
j=[k for k,l in enumerate(s) if l=='## Сделано'][0]
s.insert(j+2,'- [x] разобраться со сборкой 01.10 — устаревший кеш; ответ в треде · сделано 2026-10-02')
k=[k for k,l in enumerate(s) if l=='## Сейчас'][0]
s.insert(k+2,'- [ ] собрать итоги спринта и страницу в вики · сессия `sprint-summary` · заметка notes/sprint-summary.md')
w=[k for k,l in enumerate(s) if l=='## Жду'][0]
s.insert(w+2,'- [ ] ответ соседей по проекту про кеш · [тред](https://example.slack.com/archives/C0000000001/p1790000000000001)')
s.insert(w+2,'- [ ] релиз PROJ-200 (!300) — запущен 14:54Z, к 15:52Z не закончился · [тред](https://example.slack.com/archives/C0000000002/p1790000000000002?thread_ts=1790000000.000002&cid=C0000000002)')
open(p,'w').write('\n'.join(s))
EOF
sed -n '/## Сейчас/,/## Скоро/p;/## Жду/,/## Сделано/p' ~/projects/todo/todo.md | cut -c1-110
