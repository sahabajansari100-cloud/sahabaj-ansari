#include <stdio.h>
#include <stdlib.h>
#include <string.h>

struct Contact {
    char name[50];
    char phone[20];
    struct Contact *next;
};

struct Contact *head = NULL;

// Function to add contact
void addContact() {
    struct Contact *newNode = (struct Contact *)malloc(sizeof(struct Contact));
    printf("Enter Name: ");
    scanf("%s", newNode->name);
    printf("Enter Phone: ");
    scanf("%s", newNode->phone);
    newNode->next = NULL;

    if (head == NULL) {
        head = newNode;
    } else {
        struct Contact *temp = head;
        while (temp->next != NULL)
            temp = temp->next;
        temp->next = newNode;
    }

    printf("Contact Added Successfully!\n");
}

// Function to search contact
void searchContact() {
    char name[50];
    printf("Enter name to search: ");
    scanf("%s", name);

    struct Contact *temp = head;
    while (temp != NULL) {
        if (strcmp(temp->name, name) == 0) {
            printf("\nContact Found:\nName: %s\nPhone: %s\n", temp->name, temp->phone);
            return;
        }
        temp = temp->next;
    }

    printf("Contact Not Found!\n");
}

// Function to delete contact
void deleteContact() {
    char name[50];
    printf("Enter name to delete: ");
    scanf("%s", name);

    struct Contact *temp = head, *prev = NULL;

    while (temp != NULL && strcmp(temp->name, name) != 0) {
        prev = temp;
        temp = temp->next;
    }

    if (temp == NULL) {
        printf("Contact Not Found!\n");
        return;
    }

    if (temp == head) {
        head = head->next;
    } else {
        prev->next = temp->next;
    }

    free(temp);
    printf("Contact Deleted Successfully!\n");
}

// Function to display contacts
void displayContacts() {
    struct Contact *temp = head;

    if (temp == NULL) {
        printf("No Contacts Available!\n");
        return;
    }

    printf("\n--- Contact List ---\n");
    while (temp != NULL) {
        printf("Name: %s, Phone: %s\n", temp->name, temp->phone);
        temp = temp->next;
    }
}

int main() {
    int choice;

    while (1) {
        printf("\n--- Contact Management System ---\n");
        printf("1. Add Contact\n");
        printf("2. Search Contact\n");
        printf("3. Delete Contact\n");
        printf("4. Display Contacts\n");
        printf("5. Exit\n");
        printf("Enter your choice: ");
        scanf("%d", &choice);

        switch (choice) {
            case 1: addContact(); break;
            case 2: searchContact(); break;
            case 3: deleteContact(); break;
            case 4: displayContacts(); break;
            case 5: exit(0);
            default: printf("Invalid Choice!\n");
        }
    }

    return 0;
}
