import Animated, { useSharedValue, useAnimatedStyle, withTiming } from 'react-native-reanimated';
import { Pressable } from 'react-native';

export default function AnimatedBox() {
  const scale = useSharedValue(1);
  const animStyle = useAnimatedStyle(() => ({ transform: [{ scale: scale.value }] }));

  return (
    <Pressable
      onPress={() => {
        scale.value = withTiming(scale.value === 1 ? 1.2 : 1, { duration: 300 });
      }}
    >
      <Animated.View style={[{ width: 100, height: 100, backgroundColor: 'blue' }, animStyle]} />
    </Pressable>
  );
}
