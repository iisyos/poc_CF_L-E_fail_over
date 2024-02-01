"use strict";

exports.handler = (event, context, callback) => {
  const request = event.Records[0].cf.request;
  const uid = request.headers.uid ?? "NoUid";
  console.log(`uid: ${JSON.stringify(uid)}`);

  callback(null, request);
};
