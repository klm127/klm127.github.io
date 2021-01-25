const defaultQuotes = [{
    author: 'William Wallace',
    text: 'Freeeedooooom'
  }, {
    author: 'Ben Franklin',
    text: 'He would sacrifice their liberty for a little perceived security, deserves neither liberty nor security and will receive neither.'
  }];
  
  class QuoteBox extends React.Component {
    constructor(props) {
      super(props);
      this.state = {
        allQuotes: props.Quotes,
        currentQuote: this.getRandomQuote(props.Quotes)
      };
      this.newQuoteClick = this.newQuoteClick.bind(this);
    }
  
    getRandomQuote(quoteArray) {
      return quoteArray[Math.floor(Math.random() * quoteArray.length)];
    }
  
    newQuoteClick() {
      this.setState({
        allQuotes: this.state.allQuotes,
        currentQuote: this.getRandomQuote(this.state.allQuotes)
      });
    } //http://twitter.com/intent/tweet/?hashtags=quotes&text=
  
  
    render() {
      return /*#__PURE__*/React.createElement("div", {
        id: 'quote-box'
      }, /*#__PURE__*/React.createElement("div", {
        id: 'text',
        class: "text-center"
      }, "\"", this.state.currentQuote.text, "\""), /*#__PURE__*/React.createElement("div", {
        class: "text-center",
        id: 'author'
      }, "-", this.state.currentQuote.author), /*#__PURE__*/React.createElement("div", {
        class: "text-center"
      }, /*#__PURE__*/React.createElement("button", {
        id: 'new-quote',
        onClick: this.newQuoteClick
      }, "New Quote"), /*#__PURE__*/React.createElement("a", {
        target: "_blank",
        class: "x",
        id: "tweet-quote",
        href: "http://twitter.com/intent/tweet/?hashtags=quotes&text=" + encodeURIComponent('"' + this.state.currentQuote.text + '" ~' + this.state.currentQuote.author)
      }, "tweet")));
    }
  
    componentDidMount() {
      //for adding an svg to twitter <a>
      document.getElementById("tweet-quote").innerHTML = `<div id="twitter-image-wrap"><svg version="1.1" id="layer_1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" x="0px" y="0px"
       viewBox="0 -50 512.002 512.002" style="enable-background:new 0 0 512.002 512.002;" xml:space="preserve">
  <path style="fill:#73A1FB;" d="M500.398,94.784c-8.043,3.567-16.313,6.578-24.763,9.023c10.004-11.314,17.631-24.626,22.287-39.193
      c1.044-3.265-0.038-6.839-2.722-8.975c-2.681-2.137-6.405-2.393-9.356-0.644c-17.945,10.643-37.305,18.292-57.605,22.764
      c-20.449-19.981-48.222-31.353-76.934-31.353c-60.606,0-109.913,49.306-109.913,109.91c0,4.773,0.302,9.52,0.9,14.201
      c-75.206-6.603-145.124-43.568-193.136-102.463c-1.711-2.099-4.347-3.231-7.046-3.014c-2.7,0.211-5.127,1.734-6.491,4.075
      c-9.738,16.709-14.886,35.82-14.886,55.265c0,26.484,9.455,51.611,26.158,71.246c-5.079-1.759-10.007-3.957-14.711-6.568
      c-2.525-1.406-5.607-1.384-8.116,0.054c-2.51,1.439-4.084,4.084-4.151,6.976c-0.012,0.487-0.012,0.974-0.012,1.468
      c0,39.531,21.276,75.122,53.805,94.52c-2.795-0.279-5.587-0.684-8.362-1.214c-2.861-0.547-5.802,0.456-7.731,2.638
      c-1.932,2.18-2.572,5.219-1.681,7.994c12.04,37.591,43.039,65.24,80.514,73.67c-31.082,19.468-66.626,29.665-103.939,29.665
      c-7.786,0-15.616-0.457-23.279-1.364c-3.807-0.453-7.447,1.795-8.744,5.416c-1.297,3.622,0.078,7.66,3.316,9.736
      c47.935,30.735,103.361,46.98,160.284,46.98c111.903,0,181.907-52.769,220.926-97.037c48.657-55.199,76.562-128.261,76.562-200.451
      c0-3.016-0.046-6.061-0.139-9.097c19.197-14.463,35.724-31.967,49.173-52.085c2.043-3.055,1.822-7.094-0.545-9.906
      C507.7,94.204,503.76,93.294,500.398,94.784z"/>
  <g>
  </g>
  <g>
  </g>
  <g>
  </g>
  <g>
  </g>
  <g>
  </g>
  <g>
  </g>
  <g>
  </g>
  <g>
  </g>
  <g>
  </g>
  <g>
  </g>
  <g>
  </g>
  <g>
  </g>
  <g>
  </g>
  <g>
  </g>
  <g>
  </g>
  </svg></div>`;
    }
  
  }
  
  const settings = {
    "async": true,
    "crossDomain": true,
    "url": "https://type.fit/api/quotes",
    "method": "GET"
  };
  $.ajax(settings).done(response => {
    const data = JSON.parse(response);
    const qb = /*#__PURE__*/React.createElement(QuoteBox, {
      Quotes: data
    });
    ReactDOM.render(qb, document.getElementById("quote-root"));
  });
  