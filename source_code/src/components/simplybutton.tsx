import '../styles/buttons.css'

interface SimplyButtonProps {
  text: string;
  type: "primary" | "secondary" | "tertiary" | "danger" | "premium";
  link: string;
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