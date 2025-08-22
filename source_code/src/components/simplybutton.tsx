import '../styles/buttons.css'

interface SimplyButtonProps {
  text: string; //text to be displayed on the button
  type: "primary" | "secondary" | "tertiary" | "danger" | "premium"; //chooses the color for the button
  link: string; //link to be opened when the button is clicked
}

function SimplyButton(props: SimplyButtonProps) {
  if (props.type === "secondary") {
    return (
      <div class="button-container">
        <a href={props.link} class="button secondary dark:secondary-dark">
          {props.text}
        </a>
      </div>
    );
  } else {
    return (
      <div class="button-container">
        <a href={props.link} class={`button ${props.type}`}>
          {props.text}
        </a>
      </div>
    );
  }
}

export default SimplyButton;