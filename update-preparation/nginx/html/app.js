const APP = '3DPABLMV';

const DEBUG = true; // 'debug' in document.documentElement.mesh;

const store = isStorageAvailable(window.localStorage)
	? window.localStorage
	: null;

if (!store) {
	console.warn(`[${APP}]`, 'Local storage unavailable');
}

/**
 * @param {number[]} array
 *
 * @returns {number}
 */
function calculateStandardDeviation(array) {
	if (!array || array.length === 0) {
		return 0;
	}

	const n = array.length;
	const mean = array.reduce((a, b) => a + b) / n;
	return Math.sqrt(array.map(x => Math.pow(x - mean, 2)).reduce((a, b) => a + b) / n);
}

/**
 * @param {HTMLOutputElement} outputElement
 * @param {Object}            data
 *
 * @returns {Promise<[number, PlotlyHTMLElement]>}
 */
function drawGraph(graphElement, stdElement, data) {
	const promises = [];

	promises.push(new Promise((resolve, reject) => {
		try {
			const std = calculateStandardDeviation(data.flat()).toFixed(3);
			stdElement.value = `Standard Deviation: ${std} mm`;
			resolve(std);
		} catch (error) {
			reject(error);
		}
	}));

	const graphData = [
		{
			z: data,
			type: 'surface',
			contours: {
				z: {
					show: true,
					usecolormap: true,
					highlightcolor: "#42F462",
					project: {
						z: true,
					},
				},
			},
		},
	];

	const graphLayout = {
		autosize: true,
		margin: {
			l: 0,
			r: 0,
			b: 0,
			t: 0,
		},
		scene: {
			zaxis: {
				autorange: false,
				range: [ -4, 4 ],
			},
			camera: {
				eye: {
					x: 0,
					y: -1.25,
					z: 1.25,
				},
			},
		},
	};

	const graphConfig = {
		responsive: true
	};

	const graphPromise = Plotly.react(graphElement, graphData, graphLayout, graphConfig);
	graphPromise.finally(() => graphElement.ariaBusy = null);
	promises.push(graphPromise);

	return Promise.all(promises);
}

/**
 * Removes extraneous line endings from the beginning and ending of the input.
 *
 * @param {string} value
 *
 * @returns {string}
 */
function filterOuterLineEndings(value) {
	return value.replace(/^[\r\n]+|[\r\n]+$/g, '');
}

/**
 * Sanitizes each row and column for the visualizer to process the data.
 *
 * @param {string} rawData
 *
 * @returns {string}
 */
function filterRawData(rawData) {
	rawData = rawData.split('\n');

	if (rawData[0].trim().match(/^0\s+[\s\d]+\d$/)) {
		rawData.shift();
	}

	for (const i in rawData) {
		rawData[i] = rawData[i]
			.trim()
			.replace(/< \d+:\d+:\d+(\s+(AM|PM))?:/g, '')
			.replace(/[\[\]]/g, ' ')
			.replace(/\s+/g, '\t')
			.split('\t')
			.map((point) => parseFloat(point));

		if (rawData[i][0] == i) {
			rawData[i].shift();
		}
	}

	return rawData;
}

/**
 * Determines whether a Web Storage API is both supported and available.
 *
 * @link https://developer.mozilla.org/en-US/docs/Web/API/Web_Storage_API/Using_the_Web_Storage_API#Feature-detecting_localStorage
 *
 * @param  {Storage} storage
 * @returns {boolean}
 */
function isStorageAvailable(storage) {
	try {
		const x = '__storage_test__';
		storage.setItem(x, x);
		storage.removeItem(x);
		return true;
	} catch (error) {
		return error instanceof DOMException && (
			// everything except Firefox
			error.code === 22 ||
			// Firefox
			error.code === 1014 ||
			// test name field too, because code might not be present
			// everything except Firefox
			error.name === 'QuotaExceededError' ||
			// Firefox
			error.name === 'NS_ERROR_DOM_QUOTA_REACHED') &&
			// acknowledge QuotaExceededError only if there's something already stored
			(storage && storage.length !== 0);
	}
}

/**
 * Determines whether the specified error is a storage quota exceeded.
 *
 * @param  {Error} error
 * @returns {boolean}
 */
function isStorageQuotaExceeded(error) {
	var quotaExceeded = false;
	if (error) {
		if (error.code) {
			switch (error.code) {
				case 22:
					quotaExceeded = true;
					break;
				case 1014:
					// Firefox
					if (error.name === 'NS_ERROR_DOM_QUOTA_REACHED') {
						quotaExceeded = true;
					}
					break;
			}
		} else if (error.number === -2147024882) {
			// Internet Explorer 8
			quotaExceeded = true;
		}
	}

	return quotaExceeded;
}

/**
 * @param {any} value
 *
 * @returns {boolean}
 */
function isTrue(value) {
	if (typeof value === 'boolean') {
		return value;
	}

	if (typeof value === 'string') {
		return value === 'true';
	}

	return !!value;
}

/**
 * Executes a callback when the DOM is loaded.
 *
 * @param {function} callback
 *
 * @returns {void}
 */
function whenDOMReady(callback) {
	if (typeof document === 'undefined') {
		return;
	}

	if (document.readyState === 'complete' || document.readyState === 'interactive') {
		return void callback();
	}

	document.addEventListener('DOMContentLoaded', callback);
}

/**
 * Executes a callback while the element's ARIA region is busy.
 *
 * If the region was already busy, the state will not be toggled afterwards.
 *
 * @param {HTMLElement} element
 * @param {function}    callback
 *
 * @returns {unknown} The return value of the callback.
 */
async function whileElementIsBusy(element, callback) {
	const isAriaBusy = isTrue(element.ariaBusy);
	if (!isAriaBusy) {
		element.ariaBusy = true;
	}

	const returnValue = await callback();

	if (!isAriaBusy) {
		element.ariaBusy = null;
	}

	return returnValue;
}

/**
 * Executes a callback while the element is read only.
 *
 * If the element was already read only, the state will not be toggled afterwards.
 *
 * @param {HTMLElement} element
 * @param {function}    callback
 *
 * @returns {unknown} The return value of the callback.
 */
async function whileElementIsReadOnly(element, callback) {
	const isReadOnly = element.readOnly;
	if (!isReadOnly) {
		element.readOnly = true;
	}

	const returnValue = await callback();

	if (!isReadOnly) {
		element.readOnly = null;
	}

	return returnValue;
}

class MeshGraphPanelElement extends HTMLElement {
	/**
	 * @param {string}                tagName
	 * @param {CustomElementRegistry} registry
	 *
	 * @returns {void}
	 */
	static register(tagName = this.tagName, registry = globalThis.customElements) {
		registry?.define(tagName, this);
	}

	static get tagName() {
		return 'v-graph-panel';
	}

	/**
	 * @type {?AbortController}
	 */
	#controller;

	connectedCallback() {
		this.#controller = new AbortController();

		this.#bindEventListeners();

		whileElementIsBusy(this, async () => {
			const inputElement = this.inputElement;

			await whileElementIsReadOnly(inputElement, async () => {
				if (!inputElement.value) {
					await this.#updateInputFromStore();
				}

				if (!inputElement.value) {
					DEBUG && console.log(`[${APP}]`, 'No input to graph');
					return;
				}

				await this.#processInput();
			});
		});
	}

	disconnectedCallback() {
		this.#controller.abort();
	}

	handleEvent(event) {
		event.preventDefault();

		if (event.target.dataset.controlAction === 'reset') {
			return this.reset();
		}

		if (event.target.dataset.controlAction === 'submit') {
			return this.submit();
		}
	}

	#bindEventListeners() {
		this.controls.forEach((control) => {
			if (![ 'reset', 'submit' ].includes(control.dataset.controlAction)) {
				return;
			}

			control.addEventListener('click', this, {
				capture: true,
				signal:  this.#controller.signal,
			});

			control.ariaDisabled = null;

			if (control.ariaDescribedby === 'mesh-control-disabled-reason') {
				control.ariaDescribedby = null;
			}
		});
	}

	#resetOutputs() {
		Plotly.purge(this.graphElement);
		this.outputElements.forEach((output) => output.value = '');
	}

	get controls() {
		return this.querySelectorAll('[data-control-target="panel"][data-control-action]');
	}

	get graphElement() {
		return this.querySelector('.c-graph');
	}

	get inputElement() {
		return this.querySelector('textarea');
	}

	get outputElements() {
		return this.querySelectorAll('output');
	}

	get statsElement() {
		return this.querySelector('.c-stats');
	}

	async reset() {
		if (isTrue(this.ariaBusy)) {
			console.warn(`[${APP}]`, `#${this.id}`, 'Cannot reset. Panel not idle.');
			return;
		}

		await whileElementIsBusy(this, async () => {
			const inputElement = this.inputElement;
			inputElement.value = '';

			if (store) {
				try {
					store.removeItem(inputElement.id);
				} catch (error) {
					console.warn(`[${APP}]`, 'Storage:', `Cannot remove value of [${inputElement.id}]:`, error);
				}
			}

			this.#resetOutputs();
		});
	}

	async submit() {
		if (isTrue(this.ariaBusy)) {
			console.warn(`[${APP}]`, `#${this.id}`, 'Cannot submit. Panel not idle.');
			return;
		}

		await whileElementIsBusy(this, async () => {
			const inputElement = this.inputElement;

			await whileElementIsReadOnly(inputElement, async () => {
				inputElement.value = filterOuterLineEndings(inputElement.value);

				if (!inputElement.value) {
					console.warn(`[${APP}]`, 'No input to graph');
					return;
				}

				if (store) {
					try {
						store.setItem(inputElement.id, inputElement.value);
					} catch (error) {
						console.warn(`[${APP}]`, 'Storage:', `Cannot store value of [${inputElement.id}]:`, (
							isStorageQuotaExceeded(error)
							? 'Storage is full'
							: error
						));
					}
				}

				await this.#processInput();
			});
		});
	}

	async #processInput() {
		return await drawGraph(
			this.graphElement,
			this.statsElement,
			filterRawData(this.inputElement.value)
		);
	}

	async #updateInputFromStore() {
		if (!store?.length) {
			DEBUG && console.log(`[${APP}]`, 'Storage:', 'Empty');
		}

		const inputElement = this.inputElement;

		try {
			const storeItem = store.getItem(inputElement.id);
			if (storeItem) {
				inputElement.value = filterOuterLineEndings(storeItem);
			}
		} catch (error) {
			console.warn(`[${APP}]`, 'Storage:', `Cannot retrieve value of [${inputElement.id}]:`, error);
		}
	}
}

class MeshGraphPanelsElement extends HTMLElement {
	/**
	 * @param {string}                tagName
	 * @param {CustomElementRegistry} registry
	 *
	 * @returns {void}
	 */
	static register(tagName = this.tagName, registry = globalThis.customElements) {
		registry?.define(tagName, this);
	}

	static get tagName() {
		return 'v-graph-panels';
	}

	/**
	 * @type {?AbortController}
	 */
	#controller;

	connectedCallback() {
		this.#controller = new AbortController();

		this.#bindEventListeners();
	}

	disconnectedCallback() {
		this.#controller.abort();
	}

	handleEvent(event) {
		event.preventDefault();

		if (event.target.dataset.controlAction === 'append') {
			return this.addPanel();
		}

		if (event.target.dataset.controlAction === 'reset') {
			return this.resetPanels();
		}

		if (event.target.dataset.controlAction === 'submit') {
			return this.submitPanels();
		}
	}

	addPanel() {
		DEBUG && console.group(`[${APP}]`, 'MeshActionsElement.addPanel');

		const container = document.querySelector('#mesh-panel-container');
		if (!container) {
			console.warn(`[${APP}]`, 'Cannot add panel:', 'Missing container');

			this.appenders.forEach((appender) => appender.ariaDisabled = true);

			DEBUG && console.groupEnd();
			return;
		}

		const template = document.querySelector('#mesh-panel-template');
		if (!template) {
			console.warn(`[${APP}]`, 'Cannot add panel:', 'Missing template');

			this.appenders.forEach((appender) => appender.ariaDisabled = true);

			DEBUG && console.groupEnd();
			return;
		}

		const clone = template.content.cloneNode(true);

		clone.childNodes.forEach((child) => {
			child.innerHTML = child.innerHTML
				.replace('{$index}', container.childElementCount)
				.replace('{$iteration}', (container.childElementCount + 1))
				.replace('{$data}', '');
		});
		container.appendChild(clone);

		const counter = document.querySelector('#mesh-panel-count');
		if (counter) {
			counter.name = (Number.parseInt(counter.name) + 1);
		}

		DEBUG && console.groupEnd();
	}

	async resetPanels() {
		const promises = Array.from(this.panels).map((panel) => panel.reset());

		return await Promise.allSettled(promises);
	}

	async submitPanels() {
		const promises = Array.from(this.panels).map((panel) => panel.submit());

		return await Promise.allSettled(promises);
	}

	#bindEventListeners() {
		this.controls.forEach((control) => {
			if (![ 'append', 'reset', 'submit' ].includes(control.dataset.controlAction)) {
				return;
			}

			control.addEventListener('click', this, {
				capture: true,
				signal:  this.#controller.signal,
			});

			control.ariaDisabled = null;

			if (control.ariaDescribedby === 'mesh-control-disabled-reason') {
				control.ariaDescribedby = null;
			}
		});
	}

	get controls() {
		return this.querySelectorAll('[data-control-target="panels"][data-control-action]');
	}

	get panels() {
		return this.querySelectorAll(MeshGraphPanelElement.tagName);
	}
}

whenDOMReady(() => {
	MeshGraphPanelElement.register();
	MeshGraphPanelsElement.register();
});
