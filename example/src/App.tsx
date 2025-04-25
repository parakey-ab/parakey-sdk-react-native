import { configure, initialize, showScan } from 'parakey-sdk-react-native';
import { Text, View, StyleSheet, Button } from 'react-native';

export default function App() {
  return (
    <View style={styles.container}>
      <Text>Hello Parakey SDK</Text>
      <Button title="Open SDK" onPress={pressedButton} />
    </View>
  );
}

async function pressedButton() {
  const tokenBundle = 'example token';
  console.log('Presenting SDK!');

  await initialize();
  try {
    await configure(tokenBundle);
    await showScan();
  } catch (error) {
    if (isNativeModuleError(error)) {
      console.log(error.code);
    } else {
      console.log('Unknown error', error);
    }
  }
}

interface NativeModuleError {
  code: string;
}

function isNativeModuleError(error: unknown): error is NativeModuleError {
  return (
    typeof error === 'object' &&
    error !== null &&
    'code' in error &&
    typeof (error as any).code === 'string'
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    alignItems: 'center',
    justifyContent: 'center',
  },
});
