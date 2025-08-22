import SimplyLogInHeader from "../simplyloginheader";
import '../styles/header.css';

function SimplyHeader() {
  return (
      <header class="header">
        <div class="left">
          <a href="/"><img src="/src/long_logo.svg" alt="Simply Logo" class="logo longlogo" /></a>
        </div>
        <div class="center">
        <nav>
            <ol class="headernav">
              <li><a href="/" class="headerbutton">Home</a></li>
              <li><a href="/apps" class="headerbutton">Apps</a></li>
              <li><a href="/tools" class="headerbutton">Tools</a></li>
              <li><a href="/faq" class="headerbutton">FAQ</a></li>
              <li><a href="/about" class="headerbutton">About</a></li>
              <li><a href="/contact" class="headerbutton">Contact</a></li>
            </ol>
          </nav>
        </div>
        <div class="right">
          <SimplyLogInHeader />
        </div>
    </header>
  )
}

export default SimplyHeader;