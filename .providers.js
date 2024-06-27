const split = (values, width) => {
	stack = values.reverse();
	let result = "";
	let line = []

	while (stack.length > 0) {
		const item = '`' + stack.pop() + '`';

		if (line.join(",").length + item.length > (width - 1)) {
			result = result + line.join(",") + ",<br/>";
			line = [item];
		} else {
			line.push(item);
		}
	}
	if (line.length) {
		result = result + line.join(",");
	}
	return result;
};

split(Array.from(document.querySelectorAll("table")[0].querySelectorAll("code")).map((e) => e.innerText), 58)
