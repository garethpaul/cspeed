export interface AlertMessage {
	command: 'alert';
	text: string;
}

function containsDisplayControlCharacter(text: string): boolean {
	for (const character of text) {
		const codePoint = character.codePointAt(0);
		if (
			codePoint !== undefined &&
			(codePoint <= 0x1f ||
				codePoint === 0x00ad ||
				(codePoint >= 0x7f && codePoint <= 0x9f) ||
				(codePoint >= 0xd800 && codePoint <= 0xdfff) ||
				codePoint === 0x061c ||
				(codePoint >= 0x200b && codePoint <= 0x200d) ||
				(codePoint >= 0x200e && codePoint <= 0x200f) ||
				codePoint === 0x2028 ||
				codePoint === 0x2029 ||
				(codePoint >= 0x202a && codePoint <= 0x202e) ||
				codePoint === 0x2060 ||
				(codePoint >= 0x2061 && codePoint <= 0x2064) ||
				(codePoint >= 0x2066 && codePoint <= 0x2069) ||
				codePoint === 0xfeff)
		) {
			return true;
		}
	}

	return false;
}

export function parseAlertMessage(message: unknown): AlertMessage | undefined {
	if (!message || typeof message !== 'object') {
		return undefined;
	}

	let prototype: object | null;
	let commandDescriptor: PropertyDescriptor | undefined;
	let textDescriptor: PropertyDescriptor | undefined;
	try {
		if (Array.isArray(message)) {
			return undefined;
		}
		prototype = Object.getPrototypeOf(message);
		commandDescriptor = Object.getOwnPropertyDescriptor(message, 'command');
		textDescriptor = Object.getOwnPropertyDescriptor(message, 'text');
	} catch {
		return undefined;
	}

	if (prototype !== Object.prototype && prototype !== null) {
		return undefined;
	}
	if (
		!commandDescriptor ||
		!textDescriptor ||
		!Object.prototype.hasOwnProperty.call(commandDescriptor, 'value') ||
		!Object.prototype.hasOwnProperty.call(textDescriptor, 'value')
	) {
		return undefined;
	}

	const command = commandDescriptor.value as unknown;
	const candidateText = textDescriptor.value as unknown;
	if (command !== 'alert' || typeof candidateText !== 'string') {
		return undefined;
	}
	if (containsDisplayControlCharacter(candidateText)) {
		return undefined;
	}

	const text = candidateText.trim();
	if (text.length === 0 || text.length > 200) {
		return undefined;
	}

	return { command: 'alert', text };
}
