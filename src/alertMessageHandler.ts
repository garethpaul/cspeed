import { parseAlertMessage } from './alertMessage';

export type ShowAlert = (text: string) => unknown;

export function dispatchAlertMessage(message: unknown, showAlert: ShowAlert): boolean {
	const alert = parseAlertMessage(message);
	if (!alert) {
		return false;
	}

	showAlert(alert.text);
	return true;
}
