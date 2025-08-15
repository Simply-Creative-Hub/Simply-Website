import SimplyButton from "../simplybutton";
import { onMount, onCleanup } from "solid-js";
import './cover.css';

function ExCover() {
  let logoRef: HTMLImageElement | undefined;
  let angle = 0;
  let spinning = false;
  let frameId: number;

  const spin = () => {
    if (!logoRef || !spinning) return;
    angle += 6;
    logoRef.style.transform = `rotate(${angle}deg)`;
    frameId = requestAnimationFrame(spin);
  };

  const startSpin = () => {
    if (!logoRef || spinning) return;
    spinning = true;
    cancelAnimationFrame(frameId);
    spin();
  };

  const stopSpin = () => {
    if (!spinning) return;
    spinning = false;
    cancelAnimationFrame(frameId);
    // Keeps last angle; no reset
  };

  onMount(() => {
    if (!logoRef) return;

    // Mouse support
    logoRef.addEventListener("mousedown", startSpin);
    document.addEventListener("mouseup", stopSpin);

    // Touch support
    logoRef.addEventListener("touchstart", startSpin);
    document.addEventListener("touchend", stopSpin);

    onCleanup(() => {
      logoRef?.removeEventListener("mousedown", startSpin);
      document.removeEventListener("mouseup", stopSpin);

      logoRef?.removeEventListener("touchstart", startSpin);
      document.removeEventListener("touchend", stopSpin);
    });
  });

  return (
    <div class="cover">
      <div class="covercolumn">
        <div id="covertext">
          <h1>Welcome to Simply</h1>
          <p>A project focused on bringing a simple, clean, and powerful suite of apps.</p>
        </div>
        <div class="row">
          <SimplyButton link="/quickstart" text="Get Started" type="primary" />
          <SimplyButton link="/about" text="Learn More" type="secondary" />
        </div>
      </div>
      <div class="covercolumn">
        <img
          ref={el => (logoRef = el)}
          src="/src/logo.svg"
          alt="Simply Logo"
          id="coverlogo"
        />
      </div>
    </div>
  );
}

export default ExCover;
