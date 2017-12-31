# An exception with a `readable_message`, which can be given directly to the user.
class Dirwatch::UserFriendlyException < Exception
  # The message meant for the user.
  getter :readable_message
  @readable_message : String

  # Creates a `UserFriendlyException` with a `readable_message` and an optional `cause`.
  def initialize(@readable_message, cause : Exception? = nil)
    super
  end

  # Creates a `UserFriendlyException` with a `readable_message`, an additional `message` for internal usage and an optional `cause`.
  def initialize(@readable_message, internal_message : String, cause : Exception? = nil)
    super internal_message, cause
  end
end
