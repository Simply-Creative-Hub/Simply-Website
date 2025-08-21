import '../styles/dropdown.css'

interface SimplyDropDownProps {
    
    options: Array<string>;
}

function SimplyDropDown(props: SimplyDropDownProps) {
  return (
    <div class="dropdown-container">
        <select class="dropdown">

        </select>
    </div>
  );
}

export default SimplyDropDown;