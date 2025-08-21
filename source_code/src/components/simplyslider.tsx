import '../styles/slider.css'

interface SimplySliderProps {
    min: number;
    max: number;
    value: number;
    mindanger?: number;
    maxdanger?: number;
    mindangeralt?: number;
    maxdangeralt?: number;
    minpremium?: number;
    maxpremium?: number;
    minpremiumalt?: number;
    maxpremiumalt?: number;
    labels?: Array<string>;
}

function SimplySlider(props: SimplySliderProps) {
  return (
    <div class="slidecontainer">
        <input type="range" min={"min"} max={"max"} value={"value"} class="slider dark:slider"></input>
    </div>
  );
}

export default SimplySlider;