import { createFileRoute } from '@tanstack/solid-router'

import SimplyInput from '../../components/simplyinput'
import SimplyButton from '../../components/simplybutton'
import '../../styles/login.css'

export const Route = createFileRoute('/account/login')({
  component: RouteComponent,
})

function RouteComponent() {
  return (
    <div class="login-popup">
      <img src="/src/logo.svg" alt="Simply Logo" class="logo" />
      <form>
        <SimplyInput
          placeholder="Email"
          type="email"
          value=""
        />
        <SimplyInput
          placeholder="Password"
          type="password"
          value=""
        />
        <SimplyButton text="Login" type="primary" link="/account/dashboard" />
      </form>
    </div>
  )
}
