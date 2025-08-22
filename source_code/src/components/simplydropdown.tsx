import '../styles/dropdown.css';
import { type Component, createSignal } from 'solid-js';

interface SimplyDropDownProps {
  value: string;       // Placeholder text like "Select..."
  options: string[];   // List of selectable options
}

const SimplyDropDown: Component<SimplyDropDownProps> = (props) => {
  const [selected, setSelected] = createSignal('');

  return (
    <div class="dropdown-container">
      <select
        class="dropdown"
        value={selected()}
        onInput={(e) => setSelected(e.currentTarget.value)}
      >
        <option value="" disabled selected>
          {props.value}
        </option>
        {props.options.map((option) => (
          <option value={option}>{option}</option>
        ))}
      </select>
    </div>
  );
};

export default SimplyDropDown;