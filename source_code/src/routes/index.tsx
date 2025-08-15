import { createFileRoute } from '@tanstack/solid-router'

import SimplyHeader from '../components/simplyheader'
import ExCover from '../components/frontpage-elements/cover.frontpage'
import ExInfoBox from '../components/frontpage-elements/infobox.frontpage'

export const Route = createFileRoute('/')({
  component: IndexComponent,
})

function IndexComponent() {
  return (
    <div class="pagetop">
      <SimplyHeader />
      <ExCover />
      <div>
        <ExInfoBox heading="Powerful Apps 💪" text="Simply is your one-stop solution for all your needs. Simply has customizable tools for all your tasks." link="/apps" button="Explore Simply Apps" imagesrc="/src/frontpage/powerfultools.svg" />
        <ExInfoBox heading="Powerful Tools 🛠️" text="Simply is your one-stop solution for all your needs. Simply has customizable tools for all your tasks." link="/tools" button="Explore Simply Tools" imagesrc="/src/frontpage/powerfultools.svg" side="right" />
        <ExInfoBox heading="Accessible for All ♿" text="Our products are made with everyone in mind. We offer apps and tools for anyone, and everyone." link="/accessibility" button="Learn More" imagesrc="/src/frontpage/powerfultools.svg" />
        <ExInfoBox heading="Made with Love ❤️" text="Simply is made by a small passionate team. Supporting us makes all the difference!" link="/donate" button="Consider Donation" imagesrc="/src/frontpage/powerfultools.svg" side="right" />
      </div>
    </div>
  )
}
