cd ~/projects/work/app/docs/SRE && python3 - <<'EOF'
p='INDEX.md'; s=open(p).read().split('\n')
i=[k for k,l in enumerate(s) if l.startswith('- 2026-10-02')][0]
s[i]=s[i].rstrip()+"; END: last shift of the duty; login dip resolved (test account of store reviewers); v1.2.3 10:06Z, Watchdog CLEAN; hotfix PROJ-200 (!300) pressed 14:54Z, not deployed by 15:52Z; queue latency rising 3rd evening; handover in end-of-shift.md"
open(p,'w').write('\n'.join(s))
EOF
mkdir -p ~/projects/todo/notes; cat > ~/projects/todo/notes/sre-duty-final-report.md <<'EOF'
# Итоговый отчёт по дежурству — продолжить в понедельник

**Цель:** следующий дежурный получает полный контекст: что было, что сделано, что осталось и у кого. Плюс страница передачи в Confluence.

**Где всё лежит:**
- `~/projects/work/app/docs/SRE/INDEX.md` — строка на смену;
- `docs/SRE/<дата>/end-of-shift.md` и `activity-log.md`;
- разборы: `docs/SRE/2026-10-01/investigations/{login-drop,queue-latency}.md`.

**Что проверить перед отчётом:** дошёл ли хотфикс PROJ-200 (!300) до прода; ответы мобильной команды и Security; кто следующий дежурный.

**Правила:** только черновик; публикация в Confluence/Slack — по команде через drafts → `~/.claude/bin/review text` → `publish-approve`; факты со ссылками, догадки помечать.

**Продолжить:** `claude --resume sre-duty`.
EOF
python3 - <<'EOF'
import os
p=os.path.expanduser('~/projects/todo/todo.md'); s=open(p).read().split('\n')
def pop(prefix):
    i=[k for k,l in enumerate(s) if l.startswith(prefix)]
    return s.pop(i[0]) if i else None
pop('- [ ] передать Security провал входа 01.10')
j=[k for k,l in enumerate(s) if l=='## Сделано'][0]
s.insert(j+2,'- [x] разобраться с провалом входа 01.10 — тестовый аккаунт ревьюеров магазина приложений; Security в треде · сделано 2026-10-02')
k=[k for k,l in enumerate(s) if l=='## Сейчас'][0]
s.insert(k+2,'- [ ] собрать итоговый отчёт по дежурству для следующих дежурных и страницы передачи в Confluence · сессия `sre-duty` · заметка notes/sre-duty-final-report.md')
w=[k for k,l in enumerate(s) if l=='## Жду'][0]
s.insert(w+2,'- [ ] ответ мобильной команды про тестовый аккаунт · [тред](https://example.slack.com/archives/C0000000001/p1790000000000001)')
s.insert(w+2,'- [ ] хотфикс PROJ-200 (!300) — кнопка нажата 14:54Z, к 15:52Z в прод не ушёл · [тред](https://example.slack.com/archives/C0000000002/p1790000000000002?thread_ts=1790000000.000002&cid=C0000000002)')
open(p,'w').write('\n'.join(s))
EOF
sed -n '/## Сейчас/,/## Скоро/p;/## Жду/,/## Jira/p' ~/projects/todo/todo.md | cut -c1-110
