import {
  setTheme,
  configure,
  showScan,
  isParakeyError,
  unlock,
} from 'parakey-sdk-react-native';
import { Text, View, StyleSheet, Button } from 'react-native';

export default function App() {
  return (
    <View style={styles.container}>
      <Text>Hello Parakey SDK</Text>
      <Button title="Configure" onPress={pressedConfigure} />
      <Button title="Show scan" onPress={pressedShowScan} />
      <Button title="Unlock" onPress={pressedUnlock} />
    </View>
  );
}

async function pressedConfigure() {
  const tokenBundle = 'example token';

  try {
    await setTheme({ actionLight: '#f2c0bd', titleLight: '#e9f6ce' });
    await configure(tokenBundle);
  } catch (error) {
    if (isParakeyError(error)) {
      console.log('Configure error', error);
    } else {
      console.log('Unknown error', error);
    }
  }
}

async function pressedShowScan() {
  try {
    await showScan();
  } catch (error) {
    console.log('Show scan error', error);
  }
}

async function pressedUnlock() {
  try {
    await unlock('device-id');
  } catch (error) {
    console.log('Unlock error', error);
  }
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    gap: 16,
    alignItems: 'center',
    justifyContent: 'center',
  },
});
