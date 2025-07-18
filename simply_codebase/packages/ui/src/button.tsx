import { JSX } from 'solid-js';

interface ButtonProps {
  children: JSX.Element;
  class?: string;
  appName: string;
}

export function Button(props: ButtonProps) {
  return (
    <button
      class={props.class}
      onClick={() => alert(`Hello from your ${props.appName} app!`)}
    >
      {props.children}
    </button>
  );
}
