import '../styles/input.css'

interface SimplyInputProps {
  placeholder: string; // Placeholder text for the input
  type: "text" | "email" | "password"; // Type of the input field
  value?: string; // Current value of the input
  required?: boolean; // Optional prop to indicate if the input is required
}

function SimplyInput(props: SimplyInputProps) {
    return (
      <div class="input-container">
        <input
          type={props.type}
          placeholder={props.placeholder}
          value={props.value}
          class="input"
          {...(props.required ? { required: true } : {})}
        />
      </div>
    );
  }

export default SimplyInput;