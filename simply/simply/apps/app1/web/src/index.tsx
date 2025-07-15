import { render } from "solid-js/web"
import { Router, Route, rootRouteWithContext } from "@tanstack/solid-router"

import "./index.css"
import App from "./App"
import { Home } from "./routes/home"
import { About } from "./routes/about"

// Create a root route
const rootRoute = rootRouteWithContext<{}>()({
  component: App,
})

// Create routes
const homeRoute = new Route({
  getParentRoute: () => rootRoute,
  path: "/",
  component: Home,
})

const aboutRoute = new Route({
  getParentRoute: () => rootRoute,
  path: "/about",
  component: About,
})

// Create the route tree
const routeTree = rootRoute.addChildren([homeRoute, aboutRoute])

// Create and render the router
const router = createRouter({
  routeTree,
  defaultPreload: "intent",
})

render(() => <Router router={router} />, document.getElementById("root") as HTMLElement)

function createRouter(options: { routeTree: any; defaultPreload: string }) {
  return {
    routeTree: options.routeTree,
    defaultPreload: options.defaultPreload,
  }
}
