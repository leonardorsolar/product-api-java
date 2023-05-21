-- Active: 1684671715804@@127.0.0.1@5433@db-product@public

INSERT INTO CATEGORY (ID, DESCRIPTION) VALUES (1, 'Comic Books');

INSERT INTO CATEGORY (ID, DESCRIPTION) VALUES (2, 'Movies');

INSERT INTO CATEGORY (ID, DESCRIPTION) VALUES (3, 'Books');

INSERT INTO SUPPLIER (ID, NAME) VALUES (1, 'Panini Comics');

INSERT INTO SUPPLIER (ID, NAME) VALUES (2, 'Amazon');

INSERT INTO
    PRODUCT (
        ID,
        NAME,
        FK_SUPPLIER,
        FK_CATEGORY,
        QUANTITY_AVAILABLE
    )
VALUES (
        1,
        'Crise nas Infinitas Terras',
        1,
        1,
        10
    );

INSERT INTO
    PRODUCT (
        ID,
        NAME,
        FK_SUPPLIER,
        FK_CATEGORY,
        QUANTITY_AVAILABLE
    )
VALUES (2, 'Interestelar', 1, 1, 5);

INSERT INTO
    PRODUCT (
        ID,
        NAME,
        FK_SUPPLIER,
        FK_CATEGORY,
        QUANTITY_AVAILABLE
    )
VALUES (
        3,
        'Harry Potter E A Pedra Filosofal',
        1,
        2,
        3
    );