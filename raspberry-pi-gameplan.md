# 🍓 Raspberry Pi Game Plan for Devin
*Prepared by Windy — April 27, 2026*

---

## TL;DR Recommendation

**Buy the Raspberry Pi 5 (8GB).** Don't overthink the other models — they're mostly obsolete or underpowered for our use case. The Pi 5 is the current flagship and the only one worth buying new in 2026.

---

## The Pi Lineup Explained

Micro Center carries Pi 1 through Pi 5. Here's what you need to know:

| Model | Year | CPU | RAM | Verdict |
|-------|------|-----|-----|---------|
| Pi 1 | 2012 | Single-core 700MHz ARM | 256–512MB | Ancient. Skip. |
| Pi 2 | 2015 | Quad-core 900MHz ARM | 1GB | Outdated. Skip. |
| Pi 3 | 2016 | Quad-core 1.2GHz ARM | 1GB | Too slow for agents. Skip. |
| Pi 4 | 2019 | Quad-core 1.5GHz ARM | 1–8GB | Decent, but Pi 5 is ~3x faster for same price. Skip. |
| **Pi 5** | **2023** | **Quad-core 2.4GHz ARM Cortex-A76** | **4–16GB** | **Buy this.** |

**Why Pi 5 specifically:**
- 2–3x faster than Pi 4 in real benchmarks
- PCIe 2.0 slot — can add an NVMe SSD later if needed
- Runs cool enough with the active cooler for 24/7 use
- 8GB model handles multiple lightweight agents without sweating

---

## What to Buy at Micro Center

### ✅ Required

| Item | Price | Link |
|------|-------|------|
| **Raspberry Pi 5 (8GB)** | $169.99 | https://www.microcenter.com/product/673711/raspberry-pi-5 |
| **CanaKit 45W USB-C Power Supply** | $14.99 | https://www.microcenter.com/product/676842/canakit-45w-usb-c-power-supply-with-pd-for-raspberry-pi-5 |
| **32GB+ microSD Card (Class 10/U3)** | ~$8–12 | Grab any Class 10 card in-store |

> ⚠️ **Don't use a phone charger for power.** The Pi 5 needs 5V/5A (27W+). A regular USB-C charger will throttle performance or cause instability. The CanaKit 45W is the correct choice.

### ✅ Strongly Recommended (grab while you're there)

| Item | Price | Notes |
|------|-------|-------|
| **Raspberry Pi 5 Active Cooler** | $9.99 | https://www.microcenter.com/product/671930/raspberry-pi-5-active-cooler — clips directly onto the board. Must-have for 24/7 use. Pi 5 throttles without cooling. |
| **Official Raspberry Pi 5 Case** | ~$10–15 | Near the Pi display in-store. Snap-together, has fan vent, designed for Pi 5. |

### 💡 Optional (skip for now)

| Item | Price | Notes |
|------|-------|-------|
| Raspberry Pi M.2 HAT | $17.99 | Adds NVMe SSD support. Only if you want faster storage later. Not needed to start. |
| Short Ethernet cable | $5–10 | Only if desk doesn't have ethernet. Pi has Wi-Fi built in as fallback. |

---

## Total Cost

| Scenario | Cost |
|----------|------|
| Bare minimum (Pi + PSU + microSD) | ~$195 |
| Recommended (+ active cooler + case) | ~$215 |

---

## What This Pi Will Do For Your Setup

Your current setup runs everything on the Mac Mini — Windy, West, Rex, all crons, all monitoring. The Pi offloads the lightweight always-on work:

### West moves to the Pi
West is your heartbeat/monitoring agent — checks forms, escalates leads, monitors email. It fires every 30–60 min and uses minimal CPU. Perfect Pi workload. Mac Mini gets freed up for Claude Code builds and heavy sessions.

### Cron jobs run on the Pi
Form watchers, daily summaries, weekly reports — all move to the Pi. If the Mac Mini reboots or goes offline, these keep running.

### Redundancy
Right now if your Mac Mini loses power, everything stops. With the Pi running West independently, monitoring continues and you'll get alerted if the Mac Mini goes down.

### Client demo device
When onboarding Cadence AI Labs clients, you can demo an OpenClaw setup running live on a $170 device. That's a compelling story.

---

## The Pi Models — Full Breakdown

### Pi 1 (2012) — $5–15 used
- Single-core, 700MHz, 256–512MB RAM
- Can't run modern software reliably
- No reason to buy in 2026

### Pi 2 (2015) — $10–20 used
- Quad-core, 900MHz, 1GB RAM
- Still too slow for running agents or Node.js
- Collector item at this point

### Pi 3 B+ (2018) — ~$35
- Quad-core, 1.4GHz, 1GB RAM
- Fine for Pi-hole or basic scripts
- Not enough RAM for OpenClaw or any agent framework
- Skip

### Pi 4 (2019) — $35–75
- Quad-core, 1.5GHz, 1–8GB RAM
- Runs OpenClaw fine
- BUT: Pi 5 is ~3x faster and costs roughly the same
- Only buy if Pi 5 is sold out and you need one today

### Pi 5 (2023) — $60–169.99 ✅
- Quad-core 2.4GHz Cortex-A76, 4–16GB RAM
- PCIe 2.0 slot for NVMe SSD (future upgrade path)
- Real-time clock built in (first Pi with one)
- VideoCore VII GPU — handles light desktop use too
- **This is the one. Get the 8GB model.**

---

## Setup Plan (after you get home)

1. **Download Raspberry Pi Imager** (free) — https://www.raspberrypi.com/software/
2. **Flash the microSD** with "Raspberry Pi OS (64-bit Lite)" — the Lite version has no desktop, which is perfect for a headless server
3. **Enable SSH + set hostname + Wi-Fi** during the flash setup (click the gear icon in Imager)
4. **Assemble**: snap Pi into case, attach active cooler, insert microSD, plug in ethernet + power
5. **SSH in from your Mac**: `ssh pi@raspberrypi.local` (or whatever hostname you set)
6. **Install OpenClaw** on the Pi — same process as Mac
7. **Connect it to your Slack workspace**
8. **Move West's cron config** from Mac Mini to Pi
9. **Test for 24 hours**, then cut over

Total setup time: ~1–2 hours. Windy will walk you through every step.

---

## Why This Architecture Makes Sense

Scaleway — a major European cloud provider — rack-mounts hundreds of Mac Minis as servers. Because the Mac Mini has no remote management chip, they **embed a Raspberry Pi alongside each Mac Mini** to handle power cycling, reboots, and health monitoring. You'd be running the same two-tier architecture that a real cloud company uses in production, just at home scale.

---

*Questions? Message Windy in Slack.*
