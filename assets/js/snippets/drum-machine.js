const bankOne = [{
    keyCode: 81,
    keyTrigger: 'Q',
    id: 'Heater-1',
    url: 'https://s3.amazonaws.com/freecodecamp/drums/Heater-1.mp3'
  }, {
    keyCode: 87,
    keyTrigger: 'W',
    id: 'Heater-2',
    url: 'https://s3.amazonaws.com/freecodecamp/drums/Heater-2.mp3'
  }, {
    keyCode: 69,
    keyTrigger: 'E',
    id: 'Heater-3',
    url: 'https://s3.amazonaws.com/freecodecamp/drums/Heater-3.mp3'
  }, {
    keyCode: 65,
    keyTrigger: 'A',
    id: 'Heater-4',
    url: 'https://s3.amazonaws.com/freecodecamp/drums/Heater-4_1.mp3'
  }, {
    keyCode: 83,
    keyTrigger: 'S',
    id: 'Clap',
    url: 'https://s3.amazonaws.com/freecodecamp/drums/Heater-6.mp3'
  }, {
    keyCode: 68,
    keyTrigger: 'D',
    id: 'Open-HH',
    url: 'https://s3.amazonaws.com/freecodecamp/drums/Dsc_Oh.mp3'
  }, {
    keyCode: 90,
    keyTrigger: 'Z',
    id: "Kick-n'-Hat",
    url: 'https://s3.amazonaws.com/freecodecamp/drums/Kick_n_Hat.mp3'
  }, {
    keyCode: 88,
    keyTrigger: 'X',
    id: 'Kick',
    url: 'https://s3.amazonaws.com/freecodecamp/drums/RP4_KICK_1.mp3'
  }, {
    keyCode: 67,
    keyTrigger: 'C',
    id: 'Closed-HH',
    url: 'https://s3.amazonaws.com/freecodecamp/drums/Cev_H2.mp3'
  }];
  const bankTwo = [{
    keyCode: 81,
    keyTrigger: 'Q',
    id: 'Chord-1',
    url: 'https://s3.amazonaws.com/freecodecamp/drums/Chord_1.mp3'
  }, {
    keyCode: 87,
    keyTrigger: 'W',
    id: 'Chord-2',
    url: 'https://s3.amazonaws.com/freecodecamp/drums/Chord_2.mp3'
  }, {
    keyCode: 69,
    keyTrigger: 'E',
    id: 'Chord-3',
    url: 'https://s3.amazonaws.com/freecodecamp/drums/Chord_3.mp3'
  }, {
    keyCode: 65,
    keyTrigger: 'A',
    id: 'Shaker',
    url: 'https://s3.amazonaws.com/freecodecamp/drums/Give_us_a_light.mp3'
  }, {
    keyCode: 83,
    keyTrigger: 'S',
    id: 'Open-HH',
    url: 'https://s3.amazonaws.com/freecodecamp/drums/Dry_Ohh.mp3'
  }, {
    keyCode: 68,
    keyTrigger: 'D',
    id: 'Closed-HH',
    url: 'https://s3.amazonaws.com/freecodecamp/drums/Bld_H1.mp3'
  }, {
    keyCode: 90,
    keyTrigger: 'Z',
    id: 'Punchy-Kick',
    url: 'https://s3.amazonaws.com/freecodecamp/drums/punchy_kick_1.mp3'
  }, {
    keyCode: 88,
    keyTrigger: 'X',
    id: 'Side-Stick',
    url: 'https://s3.amazonaws.com/freecodecamp/drums/side_stick_1.mp3'
  }, {
    keyCode: 67,
    keyTrigger: 'C',
    id: 'Snare',
    url: 'https://s3.amazonaws.com/freecodecamp/drums/Brk_Snr.mp3'
  }];
  
  class Switch extends React.Component {
    constructor(props) {
      super(props);
    }
  
    render() {
      return /*#__PURE__*/React.createElement("div", {
        class: 'switch-flex'
      }, /*#__PURE__*/React.createElement("div", {
        class: 'mid'
      }, /*#__PURE__*/React.createElement("div", {
        class: 'switch-grid'
      }, /*#__PURE__*/React.createElement("div", {
        class: 'switch-name'
      }, this.props.switchName), /*#__PURE__*/React.createElement("div", {
        class: 'switch-holder'
      }, /*#__PURE__*/React.createElement("label", {
        class: 'rocker rocker-small'
      }, /*#__PURE__*/React.createElement("input", {
        type: 'checkbox',
        disabled: this.props.disabled,
        onChange: this.props.fun
      }), /*#__PURE__*/React.createElement("span", {
        class: 'switch-left'
      }, this.props.leftLabel), /*#__PURE__*/React.createElement("span", {
        class: 'switch-right'
      }, this.props.rightLabel))))));
    }
  
  }
  
  Switch.defaultProps = {
    disabled: false,
    switchName: 'Switch!',
    leftLabel: 'On',
    rightLabel: 'Off',
    fun: () => {}
  };
  
  class VolumeSlider extends React.Component {
    constructor(props) {
      super(props);
    }
  
    render() {
      return /*#__PURE__*/React.createElement("div", {
        class: 'volume-slider-container'
      }, /*#__PURE__*/React.createElement("div", {
        id: 'volume-slider-label'
      }, "Volume: ", this.props.volume), /*#__PURE__*/React.createElement("input", {
        type: 'range',
        min: '0',
        max: '100',
        value: this.props.volume,
        class: 'slider',
        id: 'volume-slider',
        onChange: this.props.fun,
        disabled: this.props.disabled
      }));
    }
  
  }
  
  VolumeSlider.defaultProps = {
    disabled: true,
    volume: 50
  };
  
  class DrumPad extends React.Component {
    constructor(props) {
      super(props);
      this.handleKey = this.handleKey.bind(this);
    }
  
    render() {
      return /*#__PURE__*/React.createElement("div", {
        class: 'drum-pad dg' + this.props.index,
        id: this.props.id,
        onClick: this.props.func
      }, this.props.keyTrigger, /*#__PURE__*/React.createElement("audio", {
        src: this.props.url,
        class: 'clip',
        id: this.props.keyTrigger
      }));
    }
  
    handleKey(event) {
      if (event.keyCode == this.props.keyCode) {
        let skeleton_event = {
          target: {
            id: this.props.id
          }
        };
        this.props.func(skeleton_event);
      }
    }
  
    componentDidMount() {
      document.addEventListener('keydown', this.handleKey);
    }
  
    componentWillUnmount() {
      document.removeEventListener('keydown', this.handleKey);
    }
  
  }
  
  class DrumMachine extends React.Component {
    constructor(props) {
      super(props);
      this.state = {
        currentBank: 1,
        banks: [bankOne, bankTwo],
        power: false,
        volume: 40
      };
      this.handlePadClick = this.handlePadClick.bind(this);
      this.powerSwitch = this.powerSwitch.bind(this);
      this.bankSwitch = this.bankSwitch.bind(this);
      this.changeVolume = this.changeVolume.bind(this);
    }
  
    render() {
      const padsRender = this.state.banks[this.state.currentBank].map((el, index) => {
        return /*#__PURE__*/React.createElement(DrumPad, {
          id: el.id,
          func: this.handlePadClick,
          keyTrigger: el.keyTrigger,
          url: el.url,
          keyCode: el.keyCode,
          index: index
        });
      });
      let isDisabled = this.state.power ? 'functional' : 'disabled';
      return /*#__PURE__*/React.createElement("div", {
        id: 'drum-machine'
      }, /*#__PURE__*/React.createElement("div", {
        id: 'drum-pads',
        class: isDisabled
      }, padsRender), /*#__PURE__*/React.createElement("div", {
        id: 'output',
        class: isDisabled
      }, /*#__PURE__*/React.createElement("div", {
        id: 'drum-display'
      }, " ---"), /*#__PURE__*/React.createElement(VolumeSlider, {
        disabled: !this.state.power,
        volume: this.state.volume,
        fun: this.changeVolume
      }), /*#__PURE__*/React.createElement("div", {
        id: 'switch-box'
      }, /*#__PURE__*/React.createElement(Switch, {
        switchName: 'Power',
        fun: this.powerSwitch
      }), /*#__PURE__*/React.createElement(Switch, {
        switchName: 'Bank',
        leftLabel: '1',
        rightLabel: '2',
        disabled: false,
        fun: this.bankSwitch
      }))));
    }
  
    handlePadClick(event) {
      if (this.state.power) {
        $("#drum-display").html(event.target.id);
        let audioEl = document.getElementById(event.target.id).children[0];
        let vol = this.state.volume / 100.0;
        audioEl.volume = vol;
        audioEl.currentTime = 0;
        audioEl.play();
      }
    }
  
    changeVolume(event) {
      this.setState({
        volume: event.target.value
      });
    }
  
    powerSwitch() {
      this.setState({
        power: !this.state.power
      });
    }
  
    bankSwitch() {
      let newbank = this.state.currentBank == 1 ? 0 : 1;
      this.setState({
        currentBank: newbank
      });
    }
  
  }
  
  ReactDOM.render( /*#__PURE__*/React.createElement(DrumMachine, null), document.getElementById("drum-machine-root"));
  