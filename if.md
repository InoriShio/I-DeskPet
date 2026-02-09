thingy macbobber: wayland quickshell sessionlock
Timer {
property bool hasReloaded
interval: 5000
repeat: true

onTriggered: {
if ( screenUnlocked && !hasReloaded ) {
hasReloaded = true;
petslocation = null;
petslocation = wherever;
}
return;
}
}
