#!/usr/bin/env python3

import psutil
import os
import time
import platform
from datetime import datetime

# ------------- CONFIG -------------
LOG_TO_FILE = False
LOG_FILE = os.path.expanduser("~/system_health.log")

# ------------- HELPERS -------------
def log(msg):
    print(msg)
    if LOG_TO_FILE:
        with open(LOG_FILE, "a") as f:
            f.write(msg + "\n")

def bytes_to_gb(b):
    return round(b / (1024 ** 3), 2)

# ------------- MAIN -------------
def system_health_report():
    timestamp = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    log(f"\n=== System Health Report ({timestamp}) ===")
    
    # Basic Info
    log(f"Hostname     : {platform.node()}")
    log(f"OS           : {platform.system()} {platform.release()}")
    log(f"Uptime       : {time.strftime('%H:%M:%S', time.gmtime(time.time() - psutil.boot_time()))}")

    # CPU
    log("\n-- CPU --")
    log(f"Logical CPUs : {psutil.cpu_count(logical=True)}")
    log(f"CPU Usage    : {psutil.cpu_percent(interval=1)}%")
    load1, load5, load15 = os.getloadavg()
    log(f"Load Average : 1min: {load1:.2f}, 5min: {load5:.2f}, 15min: {load15:.2f}")

    # Memory
    log("\n-- Memory --")
    mem = psutil.virtual_memory()
    log(f"Total        : {bytes_to_gb(mem.total)} GB")
    log(f"Used         : {bytes_to_gb(mem.used)} GB")
    log(f"Available    : {bytes_to_gb(mem.available)} GB")
    log(f"Usage        : {mem.percent}%")

    # Swap
    swap = psutil.swap_memory()
    log(f"\n-- Swap --")
    log(f"Total        : {bytes_to_gb(swap.total)} GB")
    log(f"Used         : {bytes_to_gb(swap.used)} GB")
    log(f"Free         : {bytes_to_gb(swap.free)} GB")
    log(f"Usage        : {swap.percent}%")

    # Disk
    log("\n-- Disk Usage --")
    for part in psutil.disk_partitions(all=False):
        if os.path.ismount(part.mountpoint):
            usage = psutil.disk_usage(part.mountpoint)
            log(f"{part.mountpoint:10} | Used: {bytes_to_gb(usage.used):>5} / {bytes_to_gb(usage.total):<5} GB ({usage.percent}%)")

    # Top Processes by Memory
    log("\n-- Top 5 Processes by Memory --")
    processes = sorted(psutil.process_iter(['pid', 'name', 'memory_info']), key=lambda p: p.info['memory_info'].rss, reverse=True)[:5]
    for p in processes:
        mem_mb = round(p.info['memory_info'].rss / (1024 ** 2), 1)
        log(f"PID {p.pid:<6} | {mem_mb:>6} MB | {p.info['name']}")

# ------------- RUN -------------
if __name__ == "__main__":
    system_health_report()