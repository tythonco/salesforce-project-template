import { LightningElement } from 'lwc';
import LightningConfirm from 'lightning/confirm';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

/**
 * An abstract class providing common features to inheritors
 */
export default class BaseComponent extends LightningElement {
    /** Prompt user for confirmation
     *  @param {Object<string, string>} Object Prompt options
     */
    async confirmationPrompt({ message, theme, label }) {
        return LightningConfirm.open({
            message: message || 'Are you sure?',
            theme: theme || 'warning',
            label: label || 'Confirm'
        });
    }

    /** Show a toast event with default parameters
     *  @param {Object<string, string>} Object Toast options
     */
    showNotification({ title, message, variant, mode }) {
        this.dispatchEvent(
            new ShowToastEvent({
                title: title || 'Attention',
                message: message || 'Attention',
                variant: variant || 'info',
                mode: mode || 'dismissible'
            })
        );
    }

    /**
     * Handle the given error event with default options
     * @param {HandledEvent} error
     * @param {string} label
     */
    handleError(error, label = 'There was a problem') {
        const message = error?.message || error?.body?.message || '';
        this.showNotification({
            title: 'Error',
            message: `${label}. ${message}`,
            variant: 'error',
            mode: 'sticky'
        });
    }
}
