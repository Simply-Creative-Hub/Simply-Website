import SimplyButton from '../simplybutton';
import './infobox.css';

interface SimplyInfoBoxProps {
  heading: string;
  text: string;
  imagesrc: string;
  side?: "left" | "right"; // Optional prop to determine image position
  link: string; // Optional prop for button link
  button: string; // Optional prop for button text
}

function ExInfoBox(SimplyInfoBoxProps: SimplyInfoBoxProps) {
  return SimplyInfoBoxProps.side === "right" ? (
    <div class="infoboxcontainer">
      <div class="sideimage">
        <img src={SimplyInfoBoxProps.imagesrc} alt={SimplyInfoBoxProps.heading} />
      </div>
      <div class="infobox">
        <h2>{SimplyInfoBoxProps.heading}</h2>
        <p>{SimplyInfoBoxProps.text}</p>
        <SimplyButton link={SimplyInfoBoxProps.link} text={SimplyInfoBoxProps.button} type="primary" />
      </div>
    </div>
  ) : (
    <div class="infoboxcontainer">
      <div class="infobox">
        <h2>{SimplyInfoBoxProps.heading}</h2>
        <p>{SimplyInfoBoxProps.text}</p>
        <SimplyButton link={SimplyInfoBoxProps.link} text={SimplyInfoBoxProps.button} type="primary" />
      </div>
      <div class="sideimage">
        <img src={SimplyInfoBoxProps.imagesrc} alt={SimplyInfoBoxProps.heading} />
      </div>
    </div>
  );
}
export default ExInfoBox;
