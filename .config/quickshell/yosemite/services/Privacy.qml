pragma Singleton
pragma ComponentBehavior: Bound
import qs.modules.common
import QtQuick
import Quickshell
import Quickshell.Services.Pipewire

/**
 * Screensharing and mic activity.
 */
Singleton {
    id: root

    property bool screenSharing: Pipewire.linkGroups.values.filter(PwLinkGroup => PwLinkGroup.source.type === PwNodeType.VideoSource).map(pwlg => pwlg.target)
    property bool micActive: Pipewire.linkGroups.values.filter(PwLinkGroup => PwLinkGroup.source.type === PwNodeType.AudioSource && PwLinkGroup.target.type === PwNodeType.AudioInStream).map(pwlg => pwlg.target)
}