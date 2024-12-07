class AutoComplete extends HTMLInputElement {
    constructor() {
        super();
    }

    connectedCallback() {
        this.addEventListener('keydown', this.onKeyDown.bind(this));
        this.addEventListener('keyup', this.onKeyUp.bind(this));
        this.addEventListener('blur', this.onBlur.bind(this));

        this.hiddenInput = document.createElement('input');
        this.hiddenInput.type = 'hidden';
        this.hiddenInput.name = this.name;
        this.hiddenInput.value = this.value;
        this.parentElement.appendChild(this.hiddenInput);
        this.removeAttribute('name');
        this.value = this.getAttribute('display-value');

        this.items = document.createElement('ul');
        this.items.style.display = 'none';
        this.items.style.position = 'absolute';
        this.items.className = this.autocompleteStyle || 'auto-complete-list';
        this.items.addEventListener('click', this.onItemClick.bind(this));

        this.parentElement.appendChild(this.items);
        this.lastUsedTerm = '';
    }

    set selectedItemIndex(value) {
        if (value >= this.items.childNodes.length) {
            this._selectedItemIndex = 0
        } else if (value < 0) {
            this._selectedItemIndex = this.items.childNodes.length - 1;
        } else {
            this._selectedItemIndex = value;
        }
        this.updateSelection();
    }

    async fetchData() {
        this.lastUsedTerm = this.value;
        let response = await fetch(`${this.url}/${encodeURIComponent(this.value)}`, {
            cache: 'reload',
            headers: {'Content-Type': 'application/json'},
            mode: 'cors',
            credentials: 'same-origin'
        });
        let data = await response.json();
        this.updateList(data);
    }

    updateListPosition() {
        let rect = this.getBoundingClientRect();
        this.items.style.width = rect.width + 'px';
        this.items.style.left = rect.left + 'px';
        this.items.style.top = rect.bottom + 'px';

    }

    updateList(data) {
        this.items.innerHTML = '';
        for (let item of data) {
            let li = document.createElement('li');
            li.dataset.key = item.id;
            li.dataset.value = item.value;
            li.innerText = item.label || item.value;
            this.items.appendChild(li);
        }
        this.selectedItemIndex = 0;
        this.items.style.display = 'inline-block';
        this.updateListPosition();
    }

    onBlur() {
        if (this._timeout) {
            window.clearTimeout(this._timeout);
        }

        window.setTimeout(_ => { this.items.style.display = 'none'; }, 100)
    }

    get url() {
        return this.dataset.url;
    }

    get autocompleteStyle() {
        return this.getAttribute('autocomplete-style');
    }

    get selectedItemIndex() {
        return this._selectedItemIndex;
    }

    previousItem() {
        this.selectedItemIndex--;
    }

    nextItem() {
        this.selectedItemIndex++;
    }

    updateSelection() {
        if (this.selectedItem) {
            this.selectedItem.classList.remove('selected');
        }
        this.selectedItem = this.items.childNodes[this.selectedItemIndex];
        this.selectedItem.classList.add('selected');
        this.previewItem(this.selectedItem);
    }

    previewItem(item) {
        this.value = item.innerText;
        this.hiddenInput.value = item.dataset.key;
    }

    selectItem(item) {
        this.value = item.innerText;
        this.hiddenInput.value = item.dataset.key;
        this.items.style.display = 'none';
    }

    onKeyDown(event) {
        let key = event.code.toLowerCase();
        if (['enter'].includes(key)) {
            event.preventDefault();
            event.stopPropagation();
        }
    }

    onKeyUp(event) {
        let key = event.code.toLowerCase();
        if (['arrowdown', 'enter', 'arrowup', 'insert', 'tab'].includes(key)) {
            event.preventDefault();
            event.stopPropagation();
            if (key === 'arrowdown') {
                this.nextItem();
            } else if (key === 'arrowup') {
                this.previousItem();
            } else if (key === 'enter') {
                if (this.value !== '') {
                    this.selectItem(this.selectedItem);
                } else {
                    this.value = '';
                    this.hiddenInput.value = '';
                }
            }
        } else {
            if (this.value === this.lastUsedTerm) {
                return
            }

            this.items.style.display = 'none';

            if (this._timeout) {
                window.clearTimeout(this._timeout);
            }

            if (this.value.length < this.minLength) {
                return;
            }

            this._timeout = window.setTimeout(this.fetchData.bind(this), 500);
        }
    }

    onItemClick(event) {
        let item = event.target;
        if (item.tagName.toLowerCase() === 'li') {
            this.selectItem(item);
        }
    }
}
customElements.define('auto-complete', AutoComplete, { extends: 'input' });
