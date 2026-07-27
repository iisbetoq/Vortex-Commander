import os
import shutil
from pathlib import Path

REPO = Path("/root/vortex")
HERMES = Path(os.path.expanduser("~/.hermes"))
SKILLS = HERMES / "skills"

if (REPO / "scripts/SOUL.md").exists():
    shutil.copy2(str(REPO / "scripts/SOUL.md"), str(HERMES / "SOUL.md"))

if (REPO / "scripts/vortex-skills").exists():
    shutil.copytree(str(REPO / "scripts/vortex-skills"), str(SKILLS / "vortex-skills"), dirs_exist_ok=True)
