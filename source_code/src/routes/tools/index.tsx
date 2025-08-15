import { createFileRoute } from '@tanstack/solid-router'

import SimplyHeader from '../../components/simplyheader'

export const Route = createFileRoute('/tools/')({
  component: IndexComponent,
})

function IndexComponent() {
  return (
    <div class="pagetop">
      <SimplyHeader />
    </div>
  )
}
