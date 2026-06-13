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
				(codePoint >= 0x7f && codePoint <= 0x9f) ||
				codePoint === 0x2028 ||
				codePoint === 0x2029)
		) {
			return true;
		}
	}

	return false;
}

export function parseAlertMessage(message: unknown): AlertMessage | undefined {
	if (!message || typeof message !== 'object' || Array.isArray(message)) {
		return undefined;
	}
	const prototype = Object.getPrototypeOf(message);
	if (prototype !== Object.prototype && prototype !== null) {
		return undefined;
	}

	const candidate = message as { command?: unknown; text?: unknown };
	if (
		!Object.prototype.hasOwnProperty.call(candidate, 'command') ||
		!Object.prototype.hasOwnProperty.call(candidate, 'text')
	) {
		return undefined;
	}

	if (candidate.command !== 'alert' || typeof candidate.text !== 'string') {
		return undefined;
	}
	if (containsDisplayControlCharacter(candidate.text)) {
		return undefined;
	}

	const text = candidate.text.trim();
	if (text.length === 0 || text.length > 200) {
		return undefined;
	}

	return { command: 'alert', text };
}
