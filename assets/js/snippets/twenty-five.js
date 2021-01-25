/** Created by klm127 for FreeCodeCamp certification. Passes all tests. Uses React and a tiny bit of JQuery, the latter not really being neccessary. And in 50 less lines of javascript code than the example! But a bit more CSS.
**/

/**
db(str) prints testing output to a div underneath the timer. It will print what parameter it is given on a new line. Event listener is added which allows click to clear debug area.
**/
function db(str) {
    let x = $("#test").html();
    $("#timer-debug-out").html(x + "<br />" + str);
  }
  
  document.addEventListener("DOMContentLoaded", function () {
    $("#timer-debug-out").click(event => {
      $("#timer-debug-out").html('');
    });
  });
  /**
  Ultimately I only used 1 React Component for this project. As such, if I were not making this as part of a Front End Frameworks course, I would probably not use any Framework at all, just Vanilla JS.
  **/
  
  class Timer25 extends React.Component {
    constructor(props) {
      super(props);
      this.state = {
        breakLength: 5,
        sessionLength: 25,
        currentTime: "25:00",
        mode: "Session",
        running: 0,
        //0 for stopped, 1 for running - react wasn't reading boolean for some reason
        intervalId: 0
      };
      this.breakDecrement = this.breakDecrement.bind(this);
      this.breakIncrement = this.breakIncrement.bind(this);
      this.sessionDecrement = this.sessionDecrement.bind(this);
      this.sessionIncrement = this.sessionIncrement.bind(this);
      this.reset = this.reset.bind(this);
      this.start = this.start.bind(this);
      this.stop = this.stop.bind(this);
      this.countdown = this.countdown.bind(this);
      this.switchState = this.switchState.bind(this);
    }
  
    render() {
      return /*#__PURE__*/React.createElement("div", {
        id: "timer"
      }, /*#__PURE__*/React.createElement("div", {
        id: "inner-blue-area"
      }, /*#__PURE__*/React.createElement("div", {
        id: "titlebanner"
      }, "25-5 Timer"), /*#__PURE__*/React.createElement("div", {
        id: "top-controls-container"
      }, /*#__PURE__*/React.createElement("div", {
        id: "break-container",
        className: "length-control"
      }, /*#__PURE__*/React.createElement("div", {
        id: "break-label",
        className: "control-label"
      }, "Break Length"), /*#__PURE__*/React.createElement("div", {
        id: "break-controls",
        className: "interval-control"
      }, /*#__PURE__*/React.createElement("div", {
        id: "break-decrement",
        className: "increment-button",
        onClick: this.breakDecrement
      }, "--"), /*#__PURE__*/React.createElement("div", {
        id: "break-length",
        className: "length-label"
      }, this.state.breakLength), /*#__PURE__*/React.createElement("div", {
        id: "break-increment",
        className: "increment-button",
        onClick: this.breakIncrement
      }, "++"))), /*#__PURE__*/React.createElement("div", {
        id: "session-container",
        className: "length-control"
      }, /*#__PURE__*/React.createElement("div", {
        id: "session-label",
        className: "control-label"
      }, "Session Length"), /*#__PURE__*/React.createElement("div", {
        id: "session-controls",
        className: "interval-control"
      }, /*#__PURE__*/React.createElement("div", {
        id: "session-decrement",
        className: "increment-button",
        onClick: this.sessionDecrement
      }, "--"), /*#__PURE__*/React.createElement("div", {
        id: "session-length",
        className: "length-label"
      }, this.state.sessionLength), /*#__PURE__*/React.createElement("div", {
        id: "session-increment",
        className: "increment-button",
        onClick: this.sessionIncrement
      }, "++")))), /*#__PURE__*/React.createElement("div", {
        id: "timer-container"
      }, /*#__PURE__*/React.createElement("div", {
        id: "timer-label",
        className: this.state.mode == "Session" ? "session-label" : "break-label"
      }, this.state.mode), /*#__PURE__*/React.createElement("div", {
        id: "time-left"
      }, this.state.currentTime), /*#__PURE__*/React.createElement("div", {
        id: "bottom-controls"
      }, /*#__PURE__*/React.createElement("div", {
        id: "start_stop",
        className: "bottom-control",
        onClick: this.state.running == 0 ? this.start : this.stop
      }, this.state.running == 0 ? "Start" : "Stop"), /*#__PURE__*/React.createElement("div", {
        id: "reset",
        className: "bottom-control",
        onClick: this.reset
      }, "Reset")))), /*#__PURE__*/React.createElement("audio", {
        id: "beep",
        src: "https://raw.githubusercontent.com/freeCodeCamp/cdn/master/build/testable-projects-fcc/audio/BeepSound.wav"
      }));
    }
  
    breakDecrement() {
      if (this.state.breakLength > 1) {
        //does nothing if it would take val out of range
        let newTime = '00:00'; //placeholder initializaiton - this gets overwritten; probably not necessary 
  
        let newLength = this.state.breakLength - 1;
        newLength = newLength < 10 ? "0" + newLength : newLength; //prepend a 0 on the minutes if < 10 minutes
  
        if (this.state.mode == "Break" && this.state.running == 0) {
          newTime = newLength + ':00';
        } else {
          newTime = this.state.currentTime;
        }
  
        this.setState({
          breakLength: parseInt(newLength),
          currentTime: newTime
        });
      }
    }
  
    breakIncrement() {
      if (this.state.breakLength < 60) {
        let newTime = '0:00';
        let newLength = this.state.breakLength + 1;
        newLength = newLength < 10 ? "0" + newLength : newLength;
  
        if (this.state.mode == "Break" && this.state.running == 0) {
          newTime = newLength + ':00';
        } else {
          newTime = this.state.currentTime;
        }
  
        this.setState({
          breakLength: parseInt(newLength),
          currentTime: newTime
        });
      }
    }
  
    sessionDecrement() {
      if (this.state.sessionLength > 1) {
        let newTime = '0:00';
        let newLength = this.state.sessionLength - 1;
        newLength = newLength < 10 ? "0" + newLength : newLength;
  
        if (this.state.mode == "Session" && this.state.running == 0) {
          newTime = newLength + ':00';
        } else {
          newTime = this.state.currentTime;
        }
  
        this.setState({
          sessionLength: parseInt(newLength),
          currentTime: newTime
        });
      }
    }
  
    sessionIncrement() {
      if (this.state.sessionLength < 60) {
        let newTime = '0:00'; //this doesn't matter, just wanted to initialize it
  
        let newLength = this.state.sessionLength + 1;
        newLength = newLength < 10 ? "0" + newLength : newLength; //the above conditional is used in several places to prepend the "0" when needed
  
        if (this.state.mode == "Session" && this.state.running == 0) {
          newTime = newLength + ':00';
        } else {
          newTime = this.state.currentTime;
        }
  
        this.setState({
          sessionLength: parseInt(newLength),
          currentTime: newTime
        });
      }
    }
  
    reset() {
      let audioEl = document.getElementById("beep");
      audioEl.currentTime = 0;
      audioEl.pause();
      this.stop();
      this.setState({
        breakLength: 5,
        sessionLength: 25,
        currentTime: "25:00",
        mode: "Session",
        running: 0
      });
    }
  
    start() {
      /** setInterval causes a function to be called repeatedly each interval, in this case, one second. The function to be called is defined in this class, this.countdown, which is bound to this class so it can access state. setInterval returns an intervalID which can later be used to stop the timer.**/
      let id = setInterval(this.countdown, 1000);
      this.setState({
        running: 1,
        intervalId: id
      });
    }
  
    stop() {
      let highestTimeoutId = setTimeout(";");
  
      for (let i = 0; i < highestTimeoutId; i++) {
        clearTimeout(i);
      } //this is going a little overboard with timeouts and doesn't make use of the timeout ID stored in state. But it ensures, without a doubt, that when reset or stop are clicked, everything stops.
  
  
      this.setState({
        running: 0
      });
    }
  
    switchState() {
      let audioEl = document.getElementById("beep");
      audioEl.currentTime = 0;
      audioEl.play();
  
      if (this.state.mode == "Session") {
        let b = this.state.breakLength;
        b = b < 10 ? "0" + b : b;
        this.setState({
          mode: "Break",
          currentTime: b + ':00'
        });
      } else {
        let b = this.state.sessionLength;
        b = b < 10 ? "0" + b : b;
        this.setState({
          mode: "Session",
          currentTime: b + ':00'
        });
      }
    }
  
    countdown() {
      let [min, sec] = this.state.currentTime.split(':').map(timestring => parseInt(timestring)); //countdown reads what is the current time string, splits it into minutes and seconds, then does its' operations
  
      if (min <= 0 && sec <= 0) {
        this.switchState(); //switch from break to session or vice-versa
  
        return;
      } else if (sec <= 0) {
        sec = 59; // restart a minute
  
        min--;
      } else {
        sec--;
      }
  
      min = min < 10 ? "0" + min : min; //prepend a 0 if less than 10
  
      sec = sec < 10 ? "0" + sec : sec;
      this.setState({
        currentTime: min + ':' + sec
      });
    }
  
  }
  
  ReactDOM.render( /*#__PURE__*/React.createElement(Timer25, null), document.getElementById("timer-twentyfive-root"));
  