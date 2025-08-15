import SimplyButton from "./simplybutton";

function SimplyLogInHeader() {
  return (
    <div class="login-header">
      <SimplyButton link="/account/login" text="Log In" type="secondary" />
      <SimplyButton link="/account/signup" text="Sign Up" type="primary" />
    </div>
  )
}

export default SimplyLogInHeader;