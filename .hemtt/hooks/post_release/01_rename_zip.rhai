let releases = HEMTT_RFS.join("releases");

let src = releases.join(HEMTT.project().prefix() + "-" + HEMTT.project().version().to_string() + ".zip");
let dst = releases.join(HEMTT.project().name().to_lower() + "_" + HEMTT.project().version().to_string() + ".zip");

print("Moving zip to " + dst);
if !src.move(dst) {
    warn("Failed to move " + src + " to " + dst + " (maybe --no-archive?)");
}
