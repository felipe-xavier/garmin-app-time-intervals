//! Represents the possible states of an activity in the application.
//! 
//! The activity can be in one of three states:
//! - playing: The activity is currently running and active
//! - paused: The activity is temporarily stopped but can be resumed
//! - stopped: The activity is completely stopped and needs to be started from the beginning
class ActivityStatus {
  enum {
    //! Activity is currently running and active
    playing,
    //! Activity is temporarily stopped and can be resumed
    paused,
    //! Activity is completely stopped and needs to be restarted
    stopped,
    //! Activity is past target time
    overtime,
  }
}
