import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/bank_card.dart';
import '../models/budget.dart';
import '../models/transaction_record.dart';
import '../models/user.dart';

class DatabaseService{

  final String uid;

  ///CONSTRUCTOR
  DatabaseService({this.uid});

  //Firestore collection reference
  final CollectionReference userCollection = Firestore.instance.collection('users');

  //Create new / Update document with User object
  Future updateUserData(String fullName, String email, { String avatar = '' }) async {
    return await userCollection.document(uid).setData({
      'fullName': fullName,
      'email': email,
      'avatar': avatar
    });
  }

  Future deleteUserData() async {
    return await userCollection.document(uid).delete();
  }

  //Get User document from USERS collection
  Stream<UserData> get userData{
    return userCollection.document(uid).snapshots()
    .map(_userDataFromSnapshot);
  }

  //Initialize new UserData from snapshot
  UserData _userDataFromSnapshot(DocumentSnapshot snapshot){
    return UserData(
      uid: uid,
      fullName: snapshot.data['fullName'],
      email: snapshot.data['email'],
      avatar: snapshot.data['avatar']
    );
  }

  //Firestore collection reference
  final CollectionReference budgetCollection = Firestore.instance.collection('budgets');

  //Create new / Update document with User object
  Future updateBudget(Budget budget) async {
    return await budgetCollection.document(uid).setData({
      "month": budget.month,
      "limit": budget.limit
    });
  }

  Future deleteBudget() async {
    return await budgetCollection.document(uid).delete();
  }

  //Get User document from USERS collection
  Stream<Budget> get budget{
    return budgetCollection.document(uid).snapshots()
    .map(_budgetFromSnapshot);
  }

  //Initialize new UserData from snapshot
  Budget _budgetFromSnapshot(DocumentSnapshot snapshot){
    return Budget(
      month: snapshot.data['month'],
      limit: snapshot.data['limit'],
    );
  }


  //Firestore collection reference
  final CollectionReference transactionCollection = Firestore.instance.collection('transactions');

  //Create new document with TransactionRecord object
  Future createTransactionList() async {
    return await transactionCollection.document(uid).setData({
      "history": FieldValue.arrayUnion([]),
      "wallet": FieldValue.arrayUnion([])
    });
  }

  Future deleteUserTransactions() async {
    return await transactionCollection.document(uid).delete();
  }

  Future deleteTransactionRecord(TransactionRecord transactionRecord) async {
    return await transactionCollection.document(uid).updateData({
      "history": FieldValue.arrayRemove([
        {
          'type': transactionRecord.type,
          'title': transactionRecord.title,
          'amount': transactionRecord.amount,
          'date': transactionRecord.date,
          'cardNumber': transactionRecord.cardNumber
        }
      ])
    });
  }

  //Create new / Update document with TransactionRecord object
  Future updateTransactionList(TransactionRecord transactionRecord) async {
    return await transactionCollection.document(uid).updateData({
      "history": FieldValue.arrayUnion([
        {
          'type': transactionRecord.type,
          'title': transactionRecord.title,
          'amount': transactionRecord.amount,
          'date': transactionRecord.date,
          'cardNumber': transactionRecord.cardNumber
        }
      ])
    });
  }

  //Get TransactionRecord document from TRANSACTIONS collection
  Stream<List<dynamic>> get transactionRecord{
    // return transactionCollection.document(uid).snapshots()
    // .map(_transactionRecordFromSnapshot);

    return transactionCollection.document(uid).snapshots()
    .map(_transactionRecordFromSnapshot);
  }

  //Initialize new TransactionRecord from snapshot
  List<dynamic> _transactionRecordFromSnapshot(DocumentSnapshot snapshot){
    List<dynamic> transactions = snapshot.data['history'];

    return transactions;
  }

  //Create new / Update document with TransactionRecord object
  Future updateWallet(BankCard card) async {
    return await transactionCollection.document(uid).updateData({
      "wallet": FieldValue.arrayUnion([
        {
          'bankName' : card.bankName,
          'cardNumber': card.cardNumber,
          'holderName': card.holderName,
          'expiry': card.expiry
        }
      ])
    });
  }

  Future deleteBankCard(BankCard card) async {
    return await transactionCollection.document(uid).updateData({
      "wallet": FieldValue.arrayRemove([
        {
          'bankName' : card.bankName,
          'cardNumber': card.cardNumber,
          'holderName': card.holderName,
          'expiry': card.expiry
        }
      ])
    });
  }

    //Get TransactionRecord document from TRANSACTIONS collection
  Stream<List<dynamic>> get wallet{
    // return transactionCollection.document(uid).snapshots()
    // .map(_transactionRecordFromSnapshot);

    return transactionCollection.document(uid).snapshots()
    .map(_walletFromSnapshot);
  }

  //Initialize new TransactionRecord from snapshot
  List<dynamic> _walletFromSnapshot(DocumentSnapshot snapshot){
    List<dynamic> wallet = snapshot.data['wallet'];

    return wallet;
  }

}