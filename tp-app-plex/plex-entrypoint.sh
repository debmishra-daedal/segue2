#!/bin/bash

# Plex Media Server Custom Entry Point
# This script displays connection information and manages Plex startup

echo "================================================="
echo "🎬 Plex Media Server - Container Starting"
echo "================================================="

# Get container network information
CONTAINER_IP=$(hostname -i 2>/dev/null || echo "Not available")
HOSTNAME=$(hostname)
USERNAME=$(HOST_SEGUE2_USER:-$(whoami))

# Get host IP (from docker network)
# In your plex-entrypoint.sh, you could add:
HOST_IP=$(ip route get 1 | awk '{print $7}' | head -1)
# or HOST_IP=$(hostname -I | awk '{print $1}')

echo "📋 Connection Information:"
echo "   🖥️  Hostname: $HOSTNAME"
echo "   🌐 Container IP: $CONTAINER_IP"
echo "   🏠 Host Access: http://${HOST_IP}:32400/web"
echo "   🔗 Local Access: http://localhost:32400/web"
echo "   👤 User: ${HOST_SEGUE2_USER:-$(whoami)}"
echo "   📋 Claim Token: ${PLEX_CLAIM:-Not set}"
echo ""
echo "📁 Volume Mounts:"
echo "   📦 Config: /config"
echo "   🎞️  Media: /media"
echo "   🔄 Transcode: /transcode"
echo "   📺 HOST MEDIA LOCATION: ${HOST_MEDIA_PATH:-/media}"
echo ""
echo "⚙️  Settings:"
echo "   🔍 Auto-scan: Disabled (Manual scan only)"
echo "   👤 User ID: ${PLEX_UID:-1000}"
echo "   👥 Group ID: ${PLEX_GID:-1000}"
echo "   🌍 Timezone: ${TZ:-UTC}"
echo ""

# Create Plex preferences directory if it doesn't exist
PLEX_PREFS_DIR="/config/Library/Application Support/Plex Media Server"
mkdir -p "$PLEX_PREFS_DIR"

# Create Preferences.xml with auto-scan disabled settings
PREFERENCES_FILE="$PLEX_PREFS_DIR/Preferences.xml"

# Only create preferences file if it doesn't exist (don't overwrite user settings)
if [ ! -f "$PREFERENCES_FILE" ]; then
    echo "📝 Creating initial Plex preferences (auto-scan disabled)..."
    cat > "$PREFERENCES_FILE" << EOF
<?xml version="1.0" encoding="utf-8"?>
<Preferences 
    ScheduledLibraryUpdateInterval="-1"
    GenerateIndexFilesDuringAnalysis="0"
    GenerateChapterThumbsDuringAnalysis="0"
    GenerateBIFFilesDuringAnalysis="0"
    LoudnessAnalysisDuringAnalysis="0"
    GenerateIntroMarkersDuringAnalysis="0"
    AnalyzeAudioDuringAnalysis="0"
    EnableIPv6="0"
    LogVerbose="0"
    TranscoderQuality="2"
    TranscoderH264BackgroundPreset="fast"
    BackgroundQueueIdlePaused="1"
    ButlerTaskGenerateAutoTags="0"
    ButlerTaskDeepMediaAnalysis="0"
    ButlerTaskGenerateChapterThumbs="0"
    ButlerTaskAnalyzeLoudness="0"
    ButlerTaskGenerateMarkerThumbs="0"
    ButlerTaskUpgradeMediaAnalysis="0"
    ButlerTaskOptimizeDatabase="0"
    ButlerTaskCleanOldBundles="1"
    ButlerTaskCleanOldCacheFiles="1"
    ButlerTaskRefreshLibraries="0"
    ButlerTaskRefreshEpgGuides="0"
    ButlerTaskRefreshLocalMedia="0"
/>
EOF
    chown ${PLEX_UID:-1000}:${PLEX_GID:-1000} "$PREFERENCES_FILE"
    echo "✅ Preferences created successfully"
else
    echo "ℹ️  Using existing Plex preferences"
fi

echo ""
echo "🚀 Starting Plex Media Server..."
echo "================================================="
echo ""

# Start the original Plex initialization process
exec /init "$@"
