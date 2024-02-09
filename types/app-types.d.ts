// Salesforce modules
declare module 'lightning/navigation';
declare module 'lightning/platformShowToastEvent';

// Apex methods
declare module '@salesforce/apex/LayoutService.getActiveJobStatus';
declare module '@salesforce/apex/LayoutService.getAttachmentBody';
declare module '@salesforce/apex/LayoutService.getJaccardIndices';
declare module '@salesforce/apex/LayoutService.getLayoutDetailInfo';
declare module '@salesforce/apex/LayoutService.getLayoutsForObject';
declare module '@salesforce/apex/LayoutService.getNamesOfObjectsWithLayouts';
declare module '@salesforce/apex/LayoutService.runSimilarityAnalysis';
declare module '@salesforce/apex/PermissionSetAssignmentSelector.getAssignedUsersForPermSetId';
declare module '@salesforce/apex/PermissionSetSelector.getPermissionSetGroupsForPermissionSet';
declare module '@salesforce/apex/PermissionSetService.getPermissionSetDetails';
declare module '@salesforce/apex/PermissionSetService.getSObjectFields';
declare module '@salesforce/apex/PermissionSetService.getUserPermissionFields';

// LWC/JS Modules
declare module 'c/paUtils' {
    export function safeAwait(promise: Promise<any>, finallyFunc: Function): any;
    export function formatSystemPermissionNames(input: string): string;
    export function debugLog(label: string | object, args: object ): void;
    export function capitalizeStr(input: string): string;
}

interface Modal extends HTMLElement {
    openModal: Function
}

// NOTE: Extending the typical "Event" object passed to event handlers which apparently don't
// define a "currentTarget" property Is there another Event type to use instead? Typing
// "detail" prop is tricky since it can have any prop name of any type
interface HandledEvent extends Event {
    currentTarget: HTMLElement,
    detail: any
}
