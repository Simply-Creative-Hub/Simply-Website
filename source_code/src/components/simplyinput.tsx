import '../styles/input.css'

interface SimplyInputProps {
  placeholder: string;
  type: "text" | "email" | "password";
  value: string;
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