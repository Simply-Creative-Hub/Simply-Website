import '../styles/slider.css';
import { type Component, createSignal, Show } from 'solid-js';

interface SimplySliderProps {
  min: number; // minumum value
  max: number; // maximum value
  step?: number; // step value, default is 1
  id?: string; // optional id for the input element
  name?: string; // optional name for the input element
  value: number; // current value
  mindanger?: number; // optional minimum range for red color, indicates dangerous values
  maxdanger?: number; // optional maximum range for red color, indicates dangerous values
  mindangeralt?: number; // ditto, but for secondary red range
  maxdangeralt?: number; // ditto, but for secondary red range
  minpremium?: number; // optional minimum range for purple color, indicates premium values
  maxpremium?: number; // optional maximum range for purple color, indicates premium values
  minpremiumalt?: number; // ditto, but for secondary purple range
  maxpremiumalt?: number; // ditto, but for secondary purple range
  labels?: string[]; // Index maps to value
  leftLabel?: string; // Optional label on the left side
  rightLabel?: string; // Optional label on the right side
}

const SimplySlider: Component<SimplySliderProps> = (props) => {
  const [currentValue, setCurrentValue] = createSignal(props.value);

  const getDisplayValue = () => {
    const val = currentValue();
    return props.labels && props.labels[val] !== undefined
      ? props.labels[val]
      : val;
  };

  return (
    <div class="slidecontainer">
      <div class="slider-value">{getDisplayValue()}</div>

      <div class="slider-wrapper">
        <Show when={props.leftLabel}>
          <span class="slider-side-label">{props.leftLabel}</span>
        </Show>

        <input
          type="range"
          min={props.min}
          max={props.max}
          step={props.step ?? 1}
          id={props.id}
          name={props.name}
          value={currentValue()}
          class="slider dark:slider"
          onInput={(e) => setCurrentValue(parseInt(e.currentTarget.value))}
        />

        <Show when={props.rightLabel}>
          <span class="slider-side-label">{props.rightLabel}</span>
        </Show>
      </div>
    </div>
  );
};

export default SimplySlider;