import * as React from 'react';
import { ActivityIndicator, GestureResponderEvent } from 'react-native';
import { styled } from 'nativewind';

// Wrap components that need `className` support
const Pressable = styled(require('react-native').Pressable);
const Text = styled(require('react-native').Text);

function cn(...classes: (string | undefined | false | null)[]) {
  return classes.filter(Boolean).join(' ');
}

interface SimplyButtonProps {
  title: string;
  onPress?: (event: GestureResponderEvent) => void;
  disabled?: boolean;
  loading?: boolean;
  className?: string;
}

const SimplyButton: React.FC<SimplyButtonProps> = ({
  title,
  onPress,
  disabled = false,
  loading = false,
  className = '',
}) => {
  return (
    <Pressable
      disabled={disabled || loading}
      onPress={onPress}
      className={cn(
        `px-5 py-3 rounded-md w-full items-center justify-center
         bg-primary border-b-4 border-primaryborder
         active:border-b-2 active:translate-y-0.5
         focus:outline-none focus:ring-2 focus:ring-focus
         disabled:bg-primarydisabled disabled:border-primarydisabledborder`,
        className
      )}
    >
      {loading ? (
        <ActivityIndicator color="white" />
      ) : (
        <Text className="text-white text-base font-semibold">{title}</Text>
      )}
    </Pressable>
  );
};

export default SimplyButton;