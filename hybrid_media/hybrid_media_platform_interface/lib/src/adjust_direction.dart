enum AdjustDirection {
  /// Decrease the ringer volume.
  lower,

  /// Maintain the previous ringer volume. This may be useful when needing to
  /// show the volume toast without actually modifying the volume.
  same,

  /// Increase the ringer volume.
  raise,

  /// Mute the volume. Has no effect if the stream is already muted.
  mute,

  /// Unmute the volume. Has no effect if the stream is not muted.
  unmute,

  /// Toggle the mute state. If muted the stream will be unmuted. If not muted
  /// the stream will be muted.
  toggleMute,
}
