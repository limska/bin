"""Cut the demo out of the Teams recording into a silent, captioned screencast."""

import subprocess
from pathlib import Path

SRC = "/home/sava/Downloads/IANUS Simulation providers review-20261105_140242-Meeting Recording.mp4"
OUT = Path("/home/sava/out")
OUT.mkdir(exist_ok=True)
FONT = "/usr/share/fonts/opentype/inter/Inter-SemiBold.otf"
FONT_R = "/usr/share/fonts/opentype/inter/Inter-Regular.otf"
CROP = "crop=1674:944:0:68,scale=1920:1080:flags=lanczos,setsar=1"


def t(s):  # "mm:ss" -> seconds
    m, s = s.split(":")
    return int(m) * 60 + float(s)


# (start, end, speed, step label, caption)
SEGS = [
    (
        "00:58",
        "01:36",
        2,
        "1 · Organisation",
        "Platform Mesh 0.5.2 running locally - switch to the PundK organisation",
    ),
    (
        "01:58",
        "02:22",
        1.5,
        "1 · Organisation",
        "Sign in to the Peiler und Klein organisation",
    ),
    (
        "02:52",
        "03:28",
        2,
        "1 · Organisation",
        "Open the Peiler & Klein account - the customer consuming the services",
    ),
    ("03:38", "03:50", 1, "1 · Organisation", "Peiler & Klein account dashboard"),
    (
        "07:28",
        "07:52",
        1.5,
        "2 · Material data (SKZ)",
        "Marketplace - services from several providers",
    ),
    (
        "08:24",
        "09:06",
        2,
        "2 · Material data (SKZ)",
        "Enable SKZ - Das Kunststoff-Zentrum (dummy material-data provider)",
    ),
    ("09:50", "10:36", 2, "2 · Material data (SKZ)", "Open the new SKZ Materials page"),
    (
        "10:40",
        "11:40",
        2,
        "2 · Material data (SKZ)",
        "SKZ delivers the material characterisation as JSON",
    ),
    (
        "11:40",
        "12:36",
        2,
        "2 · Material data (SKZ)",
        "Add ‘Eastman Plastics Foo 1000’ - stored as a resource in the customer workspace",
    ),
    (
        "12:40",
        "13:12",
        2,
        "3 · IANUS material database",
        "Enable IANUS Simulation - Materials",
    ),
    (
        "13:12",
        "13:46",
        1.5,
        "3 · IANUS material database",
        "Refresh - lists the materials in the StrömungsRaum backend",
    ),
    (
        "13:46",
        "14:45",
        2,
        "3 · IANUS material database",
        "Submit the SKZ material to IANUS and follow the link",
    ),
    (
        "14:45",
        "15:05",
        1,
        "3 · IANUS material database",
        "The material now exists in StrömungsRaum",
    ),
    (
        "15:20",
        "16:00",
        2,
        "4 · Injection molding simulation",
        "Enable the IANUS Injection Molding Service",
    ),
    (
        "16:00",
        "17:08",
        3,
        "4 · Injection molding simulation",
        "Add a simulation (sim2) and open StrömungsRaum",
    ),
    ("17:08", "17:55", 2, "4 · Injection molding simulation", "Pick the CAD model"),
    (
        "17:55",
        "18:25",
        2,
        "4 · Injection molding simulation",
        "Select the material Eastman Plastics Foo 1000",
    ),
    (
        "18:25",
        "18:45",
        2,
        "4 · Injection molding simulation",
        "Set the process parameters",
    ),
    (
        "18:45",
        "19:00",
        1.5,
        "4 · Injection molding simulation",
        "Mark the injection point",
    ),
    (
        "19:00",
        "19:10",
        1,
        "4 · Injection molding simulation",
        "Confirm and start the simulation",
    ),
    (
        "19:10",
        "19:50",
        2,
        "5 · Monitoring",
        "Back in the portal: refresh, select the simulation and monitor it",
    ),
    ("19:50", "20:00", 1, "5 · Monitoring", "Status: pending"),
    (
        "21:28",
        "22:15",
        3,
        "5 · Monitoring",
        "IANUS backend (internal view): the request waits for a cluster",
    ),
    (
        "22:15",
        "23:30",
        3,
        "6 · HPC execution",
        "A Slurm cluster polls the backend and picks up the job",
    ),
    ("23:30", "23:50", 2, "6 · HPC execution", "Job submitted to Slurm"),
    (
        "23:50",
        "25:10",
        5,
        "6 · HPC execution",
        "Status: processing - Slurm jobs running (squeue)",
    ),
    (
        "25:10",
        "25:35",
        1,
        "7 · Results",
        "Simulation complete - results available from the portal",
    ),
]


def esc(s):
    return (
        s.replace("\\", "\\\\")
        .replace(":", "\\:")
        .replace("'", "’")
        .replace("%", "\\%")
    )


def run(cmd):
    subprocess.run(cmd, check=True)


parts = []


# title + end cards
def card(name, lines, dur):
    vf = ["color=c=0x0f1a2b:s=1920x1080:r=30:d=%s" % dur]
    dt = []
    y = 400
    for i, (txt, size, fnt) in enumerate(lines):
        dt.append(
            f"drawtext=fontfile={fnt}:text='{esc(txt)}':fontsize={size}:fontcolor=white:x=(w-text_w)/2:y={y}"
        )
        y += size + 40
    f = OUT / f"{name}.mp4"
    run(
        [
            "ffmpeg",
            "-v",
            "error",
            "-y",
            "-f",
            "lavfi",
            "-i",
            vf[0],
            "-vf",
            ",".join(dt + ["fade=in:0:15", f"fade=out:st={dur - 0.5}:d=0.5"]),
            "-c:v",
            "libx264",
            "-preset",
            "medium",
            "-crf",
            "20",
            "-pix_fmt",
            "yuv420p",
            str(f),
        ]
    )
    return f


parts.append(
    card(
        "00_title",
        [
            ("Platform Mesh x IANUS Simulation", 72, FONT),
            (
                "From SKZ material data to an injection molding simulation on HPC",
                40,
                FONT_R,
            ),
            ("Demo - Peiler & Klein use case (ecotwin)", 32, FONT_R),
        ],
        5,
    )
)

for i, (a, b, sp, step, cap) in enumerate(SEGS, 1):
    s, e = t(a), t(b)
    vf = [
        CROP,
        f"setpts=(PTS-STARTPTS)/{sp}",
        "fps=30",
        # caption bar
        "drawbox=x=0:y=ih-120:w=iw:h=120:color=0x0f1a2b@0.85:t=fill",
        f"drawtext=fontfile={FONT_R}:text='{esc(step)}':fontsize=26:fontcolor=0x7fd3c7:x=40:y=h-108",
        f"drawtext=fontfile={FONT}:text='{esc(cap)}':fontsize=40:fontcolor=white:x=40:y=h-68",
    ]
    if sp > 1:
        vf.append(
            f"drawtext=fontfile={FONT}:text='{sp:g}x speed':fontsize=30:fontcolor=white:box=1:boxcolor=0x0f1a2b@0.75:boxborderw=12:x=w-text_w-40:y=h-100"
        )
    f = OUT / f"{i:02d}.mp4"
    run(
        [
            "ffmpeg",
            "-v",
            "error",
            "-y",
            "-ss",
            str(s),
            "-to",
            str(e),
            "-i",
            SRC,
            "-an",
            "-vf",
            ",".join(vf),
            "-c:v",
            "libx264",
            "-preset",
            "medium",
            "-crf",
            "20",
            "-pix_fmt",
            "yuv420p",
            "-r",
            "30",
            str(f),
        ]
    )
    parts.append(f)
    print(i, a, b, flush=True)

parts.append(
    card(
        "99_end",
        [
            ("Platform Mesh orchestrates - providers compute", 56, FONT),
            (
                "No computation or storage on the platform: it connects services and links to results",
                34,
                FONT_R,
            ),
        ],
        5,
    )
)

lst = OUT / "list.txt"
outfile = OUT / "platform-mesh-ianus-demo-screencast.mp4"
lst.write_text("".join(f"file '{p}'\n" for p in parts))
run(
    [
        "ffmpeg",
        "-v",
        "error",
        "-y",
        "-f",
        "concat",
        "-safe",
        "0",
        "-i",
        str(lst),
        "-c",
        "copy",
        "-movflags",
        "+faststart",
        str(outfile),
    ]
)
print("done")
